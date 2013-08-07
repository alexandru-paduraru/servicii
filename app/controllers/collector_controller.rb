class CollectorController < ApplicationController

	def index
    @customer_details = []
    if params[:search].present?
       customers = Customer.search_collector_list(params[:search], current_user)
    else
       #customers = Customer.where(:active => true, :company_id => current_user.company_id, :sent_to_collector => true )
       customers = Customer.where(:active => true, :company_id => current_user.company_id).get_collector_users()
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
	end

	def search_ajax
	  @customer_details = []
	  if params[:search]
	    customers = Customer.search_collector_list(params[:search], current_user)
	  else
	    customers = Customer.where(:active => true, :company_id => current_user.company_id).get_collector_users()
	  end

    customers.each do |customer|
      @details = {}
      @details[:customer] = customer
      open_invoices = customer.count_open_invoices
      @details[:open_invoices] = open_invoices
      @details[:number_of_open_invoices] = open_invoices.count
      @customer_details << @details
    end

		if @customer_details.count > 0
		  render :json => @customer_details.to_json
    else
      render text: 'No results have been found for your search :(', :status => 422
    end
	end
end
