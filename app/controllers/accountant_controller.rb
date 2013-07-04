class AccountantController < ApplicationController

 def index
 	@invoices = Invoice.search(params[:search])
 	render 'index'
 end
 
 def invoice_details
  	 @invoice_id = params[:invoice_id]
	 @invoice = Invoice.find(@invoice_id)
	 
	 @customer_id = @invoice.customer_id
	 @customer = Customer.find(@customer_id)
	 
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
 
 
   def invoice_create
        _post = params[:invoice]
		invoice = Invoice.new
        invoice[:amount] = _post[:amount]
        invoice[:due_date] = _post[:due_date]
        invoice[:customer_id] = _post[:customer_id]
        invoice[:date] = Time.now
        invoice[:number] = 11111 #algorithm for generating the invoice number?
        
        
        if current_user.company_id
        	invoice[:company_id] = current_user.company_id
        else
        	invoice[:company_id] = 0 
        end
        
        if invoice.save
           redirect_to customer_details_path(:customer_id => invoice[:customer_id]), :notice => "invoice successfully created"
        else
           redirect_to customer_details_path(:customer_id => invoice[:customer_id]), :error => "error creating invoice"
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
	    end
	    
	    
	    if @errors != []
	        string = ""
	        @errors.each do |error|
	        string += "Row " + error[:row].to_s+ ": " + error [:message] + "\n"
	        end
	 		redirect_to invoices_import_export_path, :notice => string
	 	else
	 	 	redirect_to invoices_import_export_path, :notice => "Invoices imported."
	 	end

   end
   
   def invoice_export
    @invoices = Invoice.all
	   	respond_to do |format|
		   	format.html {render 'invoices_import_export'}
		   	format.csv {send_data Invoice.to_csv(@invoices)}
	   	end
   end
 
end
