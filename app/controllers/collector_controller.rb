class CollectorController < ApplicationController

	def index
	    @customer_details = []
	    customers = Customer.search_collector_list(params[:search], current_user)
	    	customers.each do |customer|
	    		@details = {}
	    		@details[:customer] = customer
	    		  invoices = Customer.open_invoices(customer)
	    		  index = 0
	    		  invoices.each do |open_invoice|
	    		  	index += 1
	    		  end
	    		@details[:open_invoices] = invoices
	    		@details[:number_of_open_invoices] = index
	    		@customer_details.append(@details)
	    	end
		render 'index'
	end

        
end
