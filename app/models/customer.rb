class Customer < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller,model) {controller && controller.current_user}

  has_paper_trail
  attr_accessible :first_name, :last_name, :email, :phone, :description, :sent_to_collector, :user_id, :account, :state, :city, :zip_code, :address1, :address2, :organization_name, :industry, :company_size

  belongs_to :company
  has_many :invoices
  has_many :transactions
  has_many :actions

#   validates :first_name, :last_name, :email, :phone,:address1, :state, :city, :zip_code, :presence => true
#   validates :first_name, :last_name,:organization_name, :state, :city, :zip_code, :length => { :minimum => 2 }
#   validates :address1, :length => {:minimum => 5}
    validates :first_name, :last_name, :email, :presence => true
    validates :first_name, :last_name, :email, :length => { :minimum => 2 }
  validates_uniqueness_of :email, :account
  validates :email, :length => { :minimum => 5 } 
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
#  validates_format_of :zip_code, :with => /\A[0-9]+\Z/i  


  def recurring_invoices()
    #invoices.includes(:future_actions).where("future_actions.invoice_creation" => true)
    invoices.where("future_action_id is NOT NULL")
  end

  def self.search(search, current_user)
  	if search != ''
  		search = search.downcase
		 if Invoice.all.where(:company_id => current_user.company_id ) != []
             all :joins => 'LEFT JOIN "invoices" ON customers.id = invoices.customer_id' , :conditions => ['(lower(invoices.number) = ? or lower(customers.account) = ? or lower(customers.organization_name) LIKE ? or lower(customers.first_name) LIKE ? or lower(customers.last_name) LIKE ? or lower(customers.email) LIKE ?) and customers.company_id = ? and customers.active = ?', search, search, "#{search}%","#{search}%", "#{search}%", "%#{search}%", current_user.company_id, true], :select => 'distinct customers.organization_name, customers.first_name, customers.last_name, customers.account, customers.email, customers.id'
		 else
		    find(:all, :conditions => ['(lower(organization_name) LIKE ? or lower(first_name) LIKE ? or lower(last_name) LIKE ? or lower(email) LIKE ? or lower(account) = ?) and active = ? and company_id = ?', "#{search}%", "#{search}%" , "#{search}%", "%#{search}%", search, true, current_user.company_id])
		 end  	
    else
    	all.where(:active => true, :company_id => current_user.company_id )
    end
	# if search 
# 	search = search.downcase
# 		find(:all, :conditions => ['lower(first_name) LIKE ? or lower(last_name) LIKE ?', "%#{search}%", "%#{search}%"])
# 	else 
# 		find(:all)
# 	end
  end
  
  def self.get_collector_users()
    includes(:invoices).where("invoices.status" => "overdue")
  end


  def self.search_collector_list(search, current_user)
  	if search.present?
  		search = search.downcase
		  if Invoice.all.where(:company_id => current_user.company_id ).any?
        #all :joins => :invoices, :conditions => ['(lower(invoices.number) = ? or lower(customers.account) = ? or lower(organization_name) LIKE ? or lower(customers.first_name) LIKE ? or lower(customers.last_name) LIKE ? or lower(customers.email) LIKE ?) and customers.company_id = ? and active = ? and sent_to_collector = ?',
                              #search, search,"#{search}%","#{search}%","#{search}%", "#{search}%",
                              #current_user.company_id, true, true], :select => 'distinct customers.organization_name,
                              #customers.first_name, customers.last_name, customers.account, customers.email, customers.id')

        Customer.joins(:invoices).where('(lower(invoices.number) = ? or lower(customers.account) = ? or lower(organization_name) LIKE ? or lower(customers.first_name) LIKE ? or lower(customers.last_name) LIKE ? or lower(customers.email) LIKE ?) and customers.company_id = ? and active = ? and invoices.state = ?',
                                search, search,"#{search}%","#{search}%","#{search}%", "#{search}%",
                                current_user.company_id, true, "overdue").select('distinct customers.organization_name,
                                customers.first_name, customers.last_name, customers.account, customers.email, customers.id')
		  else
		    all.where(:active => true,:sent_to_collector => true, :company_id => current_user.company_id ).find(:all,
                  :conditions => ['lower(organization_name) LIKE ? or lower(first_name) LIKE ? or lower(last_name) LIKE ? or lower(email) LIKE ? or lower(account) = ?',
                                  "#{search}%" , "#{search}%", "#{search}%", "%#{search}%", search])
		  end	
    else
    	all.where(:active => true, :company_id => current_user.company_id, :sent_to_collector => true )
    end
  end

  def count_open_invoices
    self.invoices.where("amount > ?", 0)
  end

  def self.open_invoices(customer)
  	if customer
  	  customer.invoices.find(:all, :conditions => ['amount > ?', "0"])
  	else
  		nil
  	end
  end

  def self.last_invoice(customer)
  	if customer
  		customer.invoices.order('date asc').last
  	else
  		nil
  	end
  end

  def self.import(file, current_user)
    errors_at_import = []
    index = 1
  	CSV.foreach(file.path, headers: true) do |row|
        if customer = find_by_email(row["email"])
        else
          customer = Customer.new
        end

	  	    index += 1
	  	    customer.first_name = row["first_name"]
	  	    customer.last_name = row["last_name"]
	  	    customer.email = row["email"]
	  	    customer.phone = row["phone"]
	  	    customer.billing_address = row["billing_address"]
	  	    customer.description = row["description"]
	  		customer.company_id = current_user[:company_id]
	  		if customer.valid?
	  			customer.save
	  		else
	  		    customer.errors.full_messages.each do |error_message|
		  		    error = {}
		  		    error[:row] = index
		  		    error[:message] = error_message
		  			errors_at_import.append(error)
		  		end
	  		end
	 end
	 errors_at_import
  end

  def send_sms(sms_body, to_number = nil, from_number = nil )
    to_number ||= self.phone
    from_number ||= "+14065521383"

    account_sid = TWILIO_C['twilio']['account_sid']
    auth_token  = TWILIO_C['twilio']['auth_token']
    twilio_client = Twilio::REST::Client.new account_sid, auth_token

    message = twilio_client.account.sms.messages.create(:body => sms_body,
                :to => to_number,
                :from => from_number)

    # TODO: Add a timeline message with this
    # puts message.sid

  end

  def self.to_csv(customers)
    CSV.generate do |csv|
  		csv << column_names
  		customers.each do |customer|
  			csv << customer.attributes.values_at(*column_names)
  		end
  	end
  end

  def self.index(company_id)
     all.where(:company_id => company_id).order('created_at asc')
  end

  def self.generate_number
  	number = '1'
     if Customer.all != []
         if customer = Customer.all.order('created_at asc').last
         number = (customer[:account].to_i + 1).to_s
         end
     end
     number
  end
end
