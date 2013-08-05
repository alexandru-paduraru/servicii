class Action < ActiveRecord::Base
  include PublicActivity::Model
  tracked except: [:update,:destroy], owner: ->(controller,model) {controller && controller.current_user}
  attr_accessible :sent_at, :viewed_at, :user_id, :customer_id, :action_type, :text_note, :company_id, :invoice_id
  
  belongs_to :customer
  belongs_to :invoice

  
  validates :sent_at, :presence => true

	 
	 def self.last_action(customer)
		if customer
	  		customer.actions.order('sent_at asc').last
	  	else
	  		nil
	  	end
	 end
	 
	def self.index(company_id)
     all.where(:company_id => company_id).order('sent_at asc')
    end

  
end
