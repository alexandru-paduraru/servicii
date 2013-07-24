class SalesmanController < ApplicationController

	def index
	    @customer_detail = []
	    if params[:search]
	       customers = Customer.search(params[:search], current_user)
	    else
	       customers = Customer.all.where(:company_id => current_user.company_id, :active => true)
	    end
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
	
	def search_ajax
	    @customer_detail = []
	    if params[:search]
	       customers = Customer.search(params[:search], current_user)
	    else
	       customers = Customer.all.where(:company_id => current_user.company_id, :active => true)
	    end
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
          render :json => @customer_detail
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

  def send_sms
    customer = Customer.find(params[:customer_id])
    customer.send_sms(params[:sms_body], params[:sms_number])

    respond_to do |format|
      format.html { redirect_to customer_details_path(params[:customer_id]) }
      format.json { render :json => "1".to_json }
    end
  end
	
	def customer_details
	 @customer_id = params[:customer_id]
	 @customer = Customer.find_by_id(@customer_id)
	 @customer_last_invoice = Customer.last_invoice(@customer)
	 _customer_last_action = Action.last_action(@customer)
	 if _customer_last_action
	 @last_action = ((Time.now.to_date - _customer_last_action[:sent_at].to_date)/1.day).to_i
	 end
	 if @customer
		 @invoices = @customer.invoices
		 @open_invoices = []
			 @invoices.each do |invoice|
			 	       open_invoice = {}
			 	       open_invoice[:id] = invoice.id
			 	       open_invoice[:due_amount] = invoice.amount
			 	       open_invoice[:date] = invoice.date
			 	       open_invoice[:due_date] = invoice.due_date
			 	       open_invoice[:number] = invoice.number
			 	       @open_invoices.append(open_invoice)
			 end
		 
		 @total_due_amount = 0
		 
		 @open_invoices.each do |invoice|
		 	@total_due_amount += invoice[:due_amount]
		 end
		 
		 @actions = @customer.actions
# 		 @emails.each do |email|
# 		   EmailAction.refresh_info(email)
# 		 end
         @action_details = []
		 @actions.each do |email|
		     details = {}
		     details[:email] = email
		     details[:user] = User.find_by_id(email.user_id)
		     details[:invoice] = Invoice.find_by_id(email.invoice_id)
			# EmailAction.refresh_info(email)
			 @action_details.append(details)
	     end
		 
	 end

	render 'customer_details'
	end
	
	def customer_edit
		@customer = Customer.find_by_id(params[:customer_id])
	end
	
	def customer_update
		_post = params[:customer]
		@customer = Customer.find_by_id(params[:customer_id])
		@customer.update_attributes(:first_name => _post[:first_name],:last_name => _post[:last_name],:phone => _post[:phone], :email => _post[:email], :address1 => _post[:address1], :address2 => _post[:address2] , :organization_name => _post[:organization_name], :state => _post[:state], :city => _post[:city], :zip_code => _post[:zip_code])
		if @customer.save
			redirect_to customer_details_path(@customer.id), :notice => "Customer updated successfully!"
		else
			render 'customer_edit'
		end
	end
	
		def delete_customer
		customer_id = params[:customer_id]
		customer = Customer.find_by_id(customer_id)
				
		if customer.update_attribute(:active, false)
			redirect_to salesman_path, :notice => "Customer was made inactive."
		else
		    redirect_to salesman_path, :notice => "Error! Couldn't make customer inactive."
		end
	end
end
