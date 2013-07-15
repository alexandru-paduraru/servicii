class Action < ActiveRecord::Base
  attr_accessible :sent_at, :viewed_at, :mandrill_id, :user_id, :customer_id
  
  belongs_to :customer
  belongs_to :invoice
  
  validates :sent_at, :presence => true

	 
	 def self.last_action(customer)
		if customer
	  		customer.email_actions.order('sent_at asc').last
	  	else
	  		nil
	  	end
	 end
	 
	def self.index(company_id)
     all.where(:company_id => company_id).order('sent_at asc')
    end

  
end