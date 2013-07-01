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
 end
 
end
