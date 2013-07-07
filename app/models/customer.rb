class Customer < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :phone, :billing_address, :description, :sent_to_collector
  
  belongs_to :company
  has_many :invoices
  has_many :transactions
  has_many :email_actions
  
  validates :first_name, :last_name, :email, :phone, :billing_address, :presence => true
  validates :first_name, :last_name, :length => { :minimum => 2 }
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  def self.search(search)
  	if search
  		search = search.downcase
    	find(:all, :conditions => ['lower(first_name) LIKE ? or lower(last_name) LIKE ? or id LIKE ?', "%#{search}%" , "%#{search}%", "%#{search}%"])
    else
    	find(:all)
    end
  end
  
  def self.search_collector_list(search)
    collector_customers = []
  	if search
  		search = search.donwcase
  		collector_customers = Customer.all.where(:sent_to_collector => true).find(:all, :conditions => ['lower(first_name) LIKE ? or lower(last_name) LIKE ? or id LIKE ?', "%#{search}%" , "%#{search}%", "%#{search}%"])
  	else
  	    collector_customers = Customer.all.where(:sent_to_collector => true)
  	end
  	collector_customers
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
  
  
end
