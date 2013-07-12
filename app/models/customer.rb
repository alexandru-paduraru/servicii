class Customer < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :phone, :description, :sent_to_collector, :user_id, :account, :state, :city, :zip_code, :address1, :address2, :organization_name, :industry, :company_size
  
  belongs_to :company
  has_many :invoices
  has_many :transactions
  has_many :email_actions
  
  validates :first_name, :last_name, :email, :phone,:address1, :state, :city, :zip_code, :presence => true
  validates :first_name, :last_name,:organization_name, :state, :city, :zip_code, :length => { :minimum => 2 }
  validates :address1, :length => {:minimum => 5}
  validates_uniqueness_of :email
  validates :email, :length => { :minimum => 5 } 
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_format_of :zip_code, :with => /\A[0-9]+\Z/i  
  
  def self.search(search, current_user)
  	if search != ''
  		search = search.downcase
		 if all :joins => :invoices  
             all :joins => :invoices, :conditions => ['(invoices.number = ? or customers.account = ? or customers.first_name LIKE ? or customers.last_name LIKE ? or customers.email LIKE ?) and invoices.company_id = ? and active = ?', search, search,search, search, search, current_user.company_id, true]
		 else
		    find(:all, :conditions => ['(lower(first_name) LIKE ? or lower(last_name) LIKE ? or lower(email) LIKE ? or lower(account) LIKE ?) and active = ? and company_id = ?', "%#{search}%" , "%#{search}%", "%#{search}%", "%#{search}%", true, current_user.company_id])
		 end  	
    else
    	all.where(:active => true, :company_id => current_user.company_id )
    end
  end
  
  def self.search_collector_list(search, current_user)
  	if search != ''
  		search = search.downcase
		 if all :joins => :invoices  
             all :joins => :invoices, :conditions => ['(invoices.number = ? or customers.account = ? or customers.first_name LIKE ? or customers.last_name LIKE ? or customers.email LIKE ?) and invoices.company_id = ? and active = ? and sent_to_collector = ?', search, search,search, search, search, current_user.company_id, true, true]
		 else
		     all.where(:active => true,:sent_to_collector => true, :company_id => current_user.company_id ).find(:all, :conditions => ['lower(first_name) LIKE ? or lower(last_name) LIKE ? or lower(email) LIKE ? or lower(account) LIKE ?', "%#{search}%" , "%#{search}%", "%#{search}%", "%#{search}%"])
		 end  	
    else
    	all.where(:active => true, :company_id => current_user.company_id, :sent_to_collector => true )
    end
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
         if customer = Customer.all.order('account asc').last
         number = (customer[:account].to_i + 1).to_s
         end
     end
     number
  end
  
  
end
