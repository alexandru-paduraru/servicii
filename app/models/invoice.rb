require 'date'
class Invoice < ActiveRecord::Base
  attr_accessible :date, :due_date, :amount, :number, :customer_id, :company_id, :user_id
  
  belongs_to :company
  belongs_to :customer
  
  has_many :transactions
  has_many :email_actions
# completari many to many  

  has_many :invoice_has_services
  has_many :services, through: :invoice_has_services 

  accepts_nested_attributes_for :invoice_has_services
# sfarsit completari many to many  

   validates :date, :due_date, :amount, :number, :customer_id, :company_id, :presence => true
   validates_uniqueness_of :number
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
    
    
  def self.search(search, current_user)
  	if search != ''
  		search = search.downcase
  		if Customer.all.where(:company_id => current_user.company_id)
		all :joins => :customer, :conditions => ['(invoices.number = ? or customers.account = ?) and invoices.company_id = ?', search, search, current_user.company_id]
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
  
  def self.generate_number
  	number = 1
     if Invoice.all != []
         invoice = Invoice.all.order('number asc').last
         if invoice
         number = invoice[:number].to_i + 1
         end
     end
     number.to_s
  end
  
   def self.index(company_id)
     all.where(:company_id => company_id).order('date asc')
   end
end
