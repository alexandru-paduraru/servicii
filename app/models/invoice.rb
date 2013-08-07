require 'date'
class Invoice < ActiveRecord::Base
  include PublicActivity::Model
  tracked except: [:update,:destroy],  owner: ->(controller,model) {controller && controller.current_user}

  attr_accessible :date, :due_date, :amount, :number, :customer_id, :company_id, :user_id, :status, :state

  belongs_to :company
  belongs_to :customer

  has_one :recurring_invoice

# completari many to many  
  has_many :transactions
  has_many :actions
  has_many :invoice_has_services
  has_many :services, through: :invoice_has_services 

  accepts_nested_attributes_for :invoice_has_services
# sfarsit completari many to many  

   validates :date, :due_date, :amount, :number, :customer_id, :company_id, :presence => true
#   validates_uniqueness_of :number
#    validates :amount, :numericality => {:greater_than_or_equal_to => 0.01} - se pot scrie facturi negative
#    validate :check_date_format
#    
#    def check_date_format
#      if (Date.parse(date) rescue ArgumentError) == ArgumentError
#         errors.add(:date, 'must be a valid date')
#      end
#      
#      if (Date.parse(due_date) rescue ArgumentError) == ArgumentError
#         errors.add(:due_date, 'must be a valid date')
#      end
#    end


  DRAFT             = 1
  SENT              = 2
  VIEWED            = 3
  DISPUTED          = 4
  CURRENT           = 5
  DUE               = 6
  OVERDUE           = 7
  COLLECTION        = 8
  PAID              = 9
  PARTIAL           = 10
  PROMISE_TO_PAY    = 11
  DRAFT_AND_PARTIAL = 12

  state_machine :initial => :draft do

    event :sent_invoice do
      transition :draft => :sent
    end

    event :invoice_was_viewed do
      transition :sent => :viewed
    end

    event :mark_current do
      transition :viewed => :current, :sent => :current
    end

    event :mark_due do
      transition :current => :due
    end

    event :overdue do
      transition :due => :overdue
    end

    event :collection do
      transition :overdue => :collection
    end

    event :paid do
      transition :overdue => :paid, :due => :paid, :current => :paid
    end

    event :next_status do
      transition :draft => :sent, :sent => :current, :current => :paid, :due => :paid, :overdue => :paid
    end

    state :draft
    state :sent
    state :viewed
    state :current
    state :due
    state :overdue
    state :collection
    state :paid
    state :promised_to_pay
  end

  def next_status_based_on_current()
    if state == "draft"
      "sent"
    elsif state == "sent"
      "current"
    elsif state == "current"
      "paid"
    elsif state == "current"
      "paid"
    end
  end

  def show_state
    self.state.gsub("_", " ").capitalize rescue ""
  end

  def self.get_accountant_invoices()
    where(:state => [:draft, :sent, :viewed, :current, :due, :paid, :collection])
  end

  def self.get_collector_invoices()
    where(:state => [:collection])
  end

  def self.get_paid_for_company(company_id)
 		where(:company_id => company_id, :state => "paid")
  end

  def self.get_unpaid_for_company(company_id)
 		where("company_id = ? and (state != ? or state is NULL)", company_id, "paid")
  end

  def update_recurrency_settings!(set_recurrency, recurrent, recurrent_for)
    if set_recurrency == true
      if self.recurring_invoice.present?
        self.recurring_invoice.update_attributes(recurrent.downcase => true, "#{recurrent_for}_notification" => true)
      else
        self.create_recurring_invoice(recurrent.downcase => true, "#{recurrent_for}_notification" => true)
      end
    else
      self.recurring_invoice.destroy if self.recurring_invoice.present?
    end
  end

  def self.search(search, current_user)
  	if search != ''
  		search = search.downcase
  		if Customer.all.where(:company_id => current_user.company_id)
        all :joins => :customer, :conditions => ['(invoices.number = ? or customers.account = ? or lower(customers.organization_name) LIKE ? or lower(customers.first_name) LIKE ? or lower(customers.last_name) LIKE ?) and invoices.company_id = ?', search, search,"#{search}%","#{search}%", "#{search}%",current_user.company_id]
      else
        find(:all, :conditions => ['number = ? and company_id = ?', search, current_user.company_id])
      end
    else
      all.where(:company_id => current_user.company_id)
    end
  end

  def self.import(file, current_user)
    errors_at_import = []
    index = 1
    CSV.foreach(file.path, headers: true) do |row|
      invoice = Invoice.new
      index += 1
      invoice.date = row["date"]
      invoice.due_date = row["due_date"]
      invoice.amount = row["amount"]
      invoice.number = row["number"]
      invoice.customer_id = row["customer_id"]
      invoice.company_id = current_user[:company_id]
      if invoice.valid?
        invoice.save
      else
          invoice.errors.full_messages.each do |error_message|
            error = {}
            error[:row] = index
            error[:message] = error_message
            errors_at_import.append(error)
          end
      end
    end

   errors_at_import
  end
  
  def self.to_csv(invoices)
    CSV.generate do |csv|
      csv << column_names
      invoices.each do |invoice|
        csv << invoice.attributes.values_at(*column_names)
      end
    end
  end
  
  def self.to_csv(customer,invoice)
    services = Invoice.index_services(invoice)
    customer_columns = Customer.column_names - ["id", "created_at", "updated_at", "company_id", "sent_to_collector", "active","user_id"]
    invoice_columns = Invoice.column_names - ["id", "created_at", "updated_at", "user_id", "customer_id", "company_id"]
    CSV.generate do |csv|
        csv << customer_columns + invoice_columns
        csv << customer.attributes.values_at(*customer_columns) + invoice.attributes.values_at(*invoice_columns)
  	end
  end
  
  def self.generate_number(current_user)
    number = 1
     if Invoice.all.where(:company_id => current_user.company_id) != []
         invoice = Invoice.all.where(:company_id => current_user.company_id).order('created_at asc').last
         if invoice
           number = invoice[:number].to_i(base=10) + 1
         end
     end
     number.to_s()
  end
  
   def self.index(company_id)
     all.where(:company_id => company_id).order('date asc')
   end
   
   def self.index_services(invoice)
     services = []
     relations = invoice.invoice_has_services
    relations.each do |relation|
      service_details = {}
      service = Service.find_by_id(relation.service_id)
      service_details[:qty] = relation.qty
      service_details[:name] = service.name
      service_details[:value] = service.value
      service_details[:amount] = service_details[:value]*service_details[:qty]
      services.append(service_details)
    end
    services
   end
   
   def latest_activity
        return Action.order('sent_at desc').find(:all,:conditions => ['(action_type = ? or action_type = ? or action_type = ?) and invoice_id = ? ', 'email', 'sms', 'call', self.id])
   end
end
