class Customer < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :phone, :billing_address, :description
  
  belongs_to :company
  has_many :invoices
  has_many :transactions
  
  validates :first_name, :last_name, :email, :phone, :billing_address, :presence => true
  validates :first_name, :last_name, :length => { :minimum => 2 }
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  def self.search(search)
  	if search
    	find(:all, :conditions => ['first_name or last_name LIKE ?', "%#{search}%"])
    else
    	find(:all)
    end
  end
  
  def self.import(file, current_user)
  	CSV.foreach(file.path, headers: true) do |row|
# 	  	if a = find(:all, :conditions => ['email', row["email"]])
        if customer = find_by_email(row["email"])
	  			customer.company_id = current_user[:company_id]
	  			customer.update_attributes(row.to_hash)
	  	else
	  		customer = Customer.new(row.to_hash)
	  		customer.company_id = current_user[:company_id]
	  		customer.save
 	  	end
	 end
  end
  
end
