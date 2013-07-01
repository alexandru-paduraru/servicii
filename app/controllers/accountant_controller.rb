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
        invoice[:current_balance] = -_post[:amount].to_i
        invoice[:date] = Time.now
        invoice[:number] = 11111 #algorithm for generating the invoice number?
        
        
        if current_user.company_id
        	invoice[:company_id] = current_user.company_id
        else
        	invoice[:company_id] = 0 
        end
        
        if invoice.save
           redirect_to accountant_path
        else
           redirect_to accountant_path
        end
 
   end
 
end
