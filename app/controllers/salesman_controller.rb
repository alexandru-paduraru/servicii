class SalesmanController < ApplicationController

	def index
	
	    @customers = Customer.search(params[:search])
	    respond_to do |format|
		    format.html {render 'index'}
# 		    format.csv  {render text: Customer.to_csv(@customers) }
	    end
	end
	
	def create
		pass = {}
		object = params[:salesman]
		user = User.new
		pass = User.encrypt_password(object[:password])
		user.email = object[:email]
		user.password_salt = pass[:password_salt]
		user.password_hash = pass[:password_hash]
		user.first_name = object[:first_name]
		user.last_name = object[:last_name]
		user.job = 2
		
		if user.save 
			redirect_to admin_path
		else 
			 render text: "Eroare la inregistrare salesman, de facut pagina cu eroare si validat"
		end
	

	end
	
	def customer_details
	 @customer_id = params[:customer_id]
	 @customer = Customer.find(@customer_id)
	 
	 @invoices = @customer.invoices
	 @open_invoices = []
	 
	 @invoices.each do |invoice|
	 	if invoice.current_balance < 0
	 	       open_invoice = {}
	 	       open_invoice[:due_amount] = invoice.current_balance
	 	       open_invoice[:number] = invoice.number
	 	       @open_invoices.append(open_invoice)
		end
	 end
	 
	 @total_due_amount = 0
	 
	 @open_invoices.each do |invoice|
	 	@total_due_amount += invoice[:due_amount]
	 end
	 
	 
	 respond_to do |format|
	 	format.html {render 'customer_details'}
	 end
	
	end
end
