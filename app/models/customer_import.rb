class CustomerImport < ActiveModel::Model
	extend ActiveModel::Naming
	include ActiveModel::Conversion
	include ActiveModel::Validations
	
	atr_accessor :file
	atr_accessible 
	
	def save
	    errors = []
		if imported_customers.map(&:valid?).all?
		    imported_customers.each(&:save!)
			errors
		else
			imported_customers.each_with_index do |customer, index|
				customer.errors.full_messages.each do |message|
				 error[:index] = index + 1
				 error[:message] = message
				 errors.append(error)
				end
			end
			errors
		end
    end	
    
    def imported_customers
    	@imported_customers ||= import_customers
    
    end
	
end