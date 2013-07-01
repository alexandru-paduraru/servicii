class SalesmanController < ApplicationController

	def index
	    @customers = Customer.search(params[:search])
		render 'index'
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
	 
	 respond_to do |format|
	 	format.html {render 'customer_details'}
	 end
	
	end
end
