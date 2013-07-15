require 'mandrill' 

class AccountantController < ApplicationController

 def index
 	if  params[:search]
 		invoices = Invoice.search(params[:search], current_user)
 	else 
 		invoices = Invoice.all.where(:company_id => current_user.company_id)
 	end 
 	
 	@invoice_details = []
 	invoices.each do |invoice|
 		details = {}
 		details[:customer] = invoice.customer
 		details[:invoice] = invoice
 		@invoice_details.append(details)
 	end
 	render 'index'
 end
 
 def invoice_details
  	 @invoice_id = params[:invoice_id]
	 @invoice = Invoice.find_by_id(@invoice_id)
	 
	 @customer_id = @invoice.customer_id
	 @customer = Customer.find_by_id(@customer_id)
	 
	 @company = Company.find_by_id(current_user.company_id)
	 @services = Invoice.index_services(@invoice)
	 
	 @email_details = []
	 
	 @emails = @invoice.actions
	 @emails.each do |email|
	     details = {}
	     details[:email] = email
	     details[:user] = User.find_by_id(email.user_id)
		 EmailAction.refresh_info(email)
		 @email_details.append(details)
     end
     	 
	 respond_to do |format|
	 	format.html {render 'invoice_details'}
	 end
 end
 
	 def invoice_new
		 @invoice = Invoice.new
		 respond_to do |format|
	     	 	format.html  {render 'invoice_new'}
	     	 	format.json { render json: @invoice }
	     end
	 end

#### view for opening a new invoice from a customer details

    def customer_new_invoice
    	@invoice = Invoice.new
    	@services = []
    	customer_id = params[:customer_id]
		@customer = Customer.find_by_id(customer_id)
		@company = Company.find_by_id(current_user.company_id)
		render 'customer_new_invoice'
    end
 
   
   def invoice_create_test
   		@customer = Customer.find_by_id(params[:customer_id])
   		ok = 1
   		_post_customer = params[:customer]
   		_post_invoice = params[:invoice]
   		numberOfServices = _post_invoice[:number_of_services].to_i
   		@services = []
   		@invoice = Invoice.new(:date => Time.now, :customer_id => _post_customer[:id], :user_id => current_user.id, :company_id => current_user.company_id, :due_date => _post_invoice[:due_date], :amount => _post_invoice[:amount])
   		@invoice.number = Invoice.generate_number(current_user)
   		if @invoice.save
   			(1..numberOfServices).each do |i|
   				service = "service_" + i.to_s
   				_post_service = params[service]
   				@services.append(_post_service)
   				@relation = InvoiceHasService.new(:invoice_id => @invoice.id, :service_id => _post_service[:id], :qty => _post_service[:qty])
   				if !@relation.save
   					ok = 0
   				end 
   			end
   			if ok == 1
   				if Notifier.send_email_invoice(@invoice, @services, @customer).deliver
   					render :text => "Invoice was succesfully created! An email was sent to customer!"
   				else
   					render :text => "Invoice was succesfully created but email couldn't be sent!"
   				end
   			else 
   				render :text => "There was an error creating Invoice has service! Please contact admin!"
   			end
   		else
   			render :json => { :errors => @invoice.errors.full_messages }, :status => 422
   		end
   		
   end
   
   def create_service
   		@service = Service.new
   		_post = params[:service]
   		@service.name = _post[:name]
   		@service.value = _post[:value]
   		@service.company_id = current_user.company_id
   		if @service.save
   			render :json => @service.to_json
   		else 
   			render :json => { :errors => @service.errors.full_messages }, :status => 422
   		end
   end
   
   
   def invoice_create
        if params[:send] || params[:draft]
        _post = params[:invoice]
        ok = true
        @services = []
		@services[1] = Service.new
		@invoice = Invoice.new(:date => Time.now, :customer_id => _post[:customer_id], :user_id => current_user.id, :company_id => current_user.company_id, :due_date => _post[:due_date], :amount => _post[:amount])
		@invoice.number = Invoice.generate_number
		if !@invoice.save
			ok = false
		else
			if s1 = _post[:service_1]
			    existing_service = Service.search_name_value(s1[:service_name], s1[:service_value])
			    if existing_service != nil
				    @services[1] = existing_service
				    @rel = InvoiceHasService.new(:invoice_id => @invoice.id, :service_id => @services[1].id, :qty => s1[:service_qty])
		        	if !@rel.save 
		        		ok = false
		        	end
			    else
	        	@services[1] = Service.new(:name => s1[:service_name], :value => s1[:service_value], :company_id => @invoice[:company_id])
	        		if @services[1].save
	        			@rel = InvoiceHasService.new(:invoice_id => @invoice.id, :service_id => @services[1].id, :qty => s1[:service_qty])
	        			if !@rel.save 
	        				ok = false
	        			end
	        		else
	        		 ok = false
	        		end
	        	 end
			 end
			
		end
		
		
        
        if ok
           if params[:send]
           redirect_to customer_details_path(:customer_id => _post[:customer_id]), :notice => "Success! Invoice created. An email with details was sent to customer."
           EmailAction.send_email(_post,@invoice.id,current_user) 
           end
           if params[:draft]
           redirect_to customer_details_path(:customer_id => _post[:customer_id]), :notice => "Success! Invoice saved as draft."
           end
        else
#            redirect_to customer_details_path(:customer_id => _post[:customer_id]), :alert => "Error creating invoice ! "
 			@customer = Customer.find_by_id(_post[:customer_id])
 			render 'customer_new_invoice'
        end
     end

 
   end
   
   def invoices_import_export
   
	   respond_to do |format|
	   	format.html {render 'invoices_import_export'}
	   end
   
   end
   
   def invoice_import
   	     @errors = []
	    
	    if(params[:file])
	 		@errors = Invoice.import(params[:file], current_user)

	    
	    
		    if @errors != []
		        string = ""
		        @errors.each do |error|
		        string += "Row " + error[:row].to_s+ ": " + error [:message] + "\n"
		        end
		 		redirect_to invoices_import_export_path, :notice => string
		 	else
		 	 	redirect_to invoices_import_export_path, :notice => "Invoices imported."
		 	end
	   else # if there was no file selected
	     redirect_to invoices_import_export_path, :alert => "Choose a file!"
	   end
   end
   
   def invoice_export
    @invoices = Invoice.all
	   	respond_to do |format|
		   	format.html {render 'invoices_import_export'}
		   	format.csv {send_data Invoice.to_csv(@invoices)}
	   	end
   end
 
   def invoice_pay
   	   @invoice = Invoice.find_by_id(params[:invoice_id])
   end
   
end
