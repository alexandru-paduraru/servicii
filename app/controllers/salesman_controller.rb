class SalesmanController < ApplicationController

	def index
	    @customer_detail = []
	    customers = Customer.search(params[:search])
	    
	    	customers.each do |customer|
	    		@details = {}
	    		@details[:customer] = customer
	    		  invoices = Customer.open_invoices(customer)
	    		  index = 0
	    		  invoices.each do |open_invoice|
	    		  	index += 1
	    		  end
	    		@details[:open_invoices] = index
	    		@customer_detail.append(@details)
	    	end
	    
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
	 @customer = Customer.find_by_id(@customer_id)
	 @customer_last_invoice = Customer.last_invoice(@customer)
	 if @customer
		 @invoices = @customer.invoices
		 @open_invoices = []
		 
			 @invoices.each do |invoice|
			 	       open_invoice = {}
			 	       open_invoice[:due_amount] = invoice.amount
			 	       open_invoice[:number] = invoice.number
			 	       @open_invoices.append(open_invoice)
			 end
		 
		 @total_due_amount = 0
		 
			 @open_invoices.each do |invoice|
			 	@total_due_amount += invoice[:due_amount]
			 end
		 
		 @emails = @customer.email_actions
		 @emails.each do |email|
		   EmailAction.refresh_info(email)
		 end
		 
# 		 @info = EmailAction.user_info

	 end
	 
		 respond_to do |format|
		 	format.html {render 'customer_details'}
		 end
	
	end
	
		def delete_customer
		customer_id = params[:customer_id]
		customer = Customer.find(customer_id)
				
		if customer.update_attribute(:active, false)
			redirect_to salesman_path, :notice => "Customer was made inactive."
		else
		    redirect_to salesman_path, :notice => "Error! Couldn't make customer inactive."
		end
	end
end
