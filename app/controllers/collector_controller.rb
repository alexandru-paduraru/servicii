class CollectorController < ApplicationController

	def index
	    @customer_details = []
	    if params[:search]
	       customers = Customer.search_collector_list(params[:search], current_user)
	    else
	       customers = Customer.where(:active => true, :company_id => current_user.company_id, :sent_to_collector => true )
	    end
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

	def search_ajax
	   @customer_details = []
	   if params[:search]
	       customers = Customer.search_collector_list(params[:search], current_user)
	    else
	       customers = Customer.where(:active => true, :company_id => current_user.company_id, :sent_to_collector => true )
	    end
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
		if @customer_details.count > 0 
		    render :json => @customer_details
        else
            render text: 'No results have been found for your search :(', :status => 422
        end

	end
        
end
