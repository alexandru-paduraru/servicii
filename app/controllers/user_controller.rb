class UserController < ApplicationController
	def login
	  
	 respond_to do |format|
      	format.html  {render 'login'}
      	format.json { render json: @user }
      end
	end
	
	def new
		@user = User.new
	end
	
	def create
		pass = {}
		_post = params[:user]
		@user = User.new
		ok = 0
		@user.email = _post[:email]
		@user.password = _post[:password]
		@user.first_name = _post[:first_name]
		@user.last_name = _post[:last_name]
		@user.job = 0
		
		#render 'verifica'
		 if @user.save
 			if _post[:workson][:salesman].to_i == 1
 				workson = Workson.new
 				workson.user_id = @user[:id]
 				workson.job_id = 2
 				if workson.save
 					ok = 1
 				else ok = 0
 				end
 			end
			if _post[:workson][:accountant].to_i == 1
				workson = Workson.new
				workson.user_id = @user[:id]
				workson.job_id = 3
				if workson.save
					ok = 1
				else ok = 0
				end
			end
			if _post[:workson][:collector].to_i == 1
				workson = Workson.new
				workson.user_id = @user[:id]
				workson.job_id = 4
				if workson.save
					ok = 1
				else ok = 0
				end
			end
 			if ok == 1
 				redirect_to admin_path, :notice => "Employee was created."
 			else render text: "eroare la adaugarea job-ului"
 			end
 		else 
 			render 'new'
		end
	end
	
	def show 
		@users_details = []
		@users = User.all
		
		@users.each do |user|
			@user_detail = User.details(user.id)
			@users_details.append(@user_detail)
		end
		render 'verifica'
	end
	
	def index
		if(current_user)
			@user_details = User.details(current_user.id)
			render 'index' 
		end
	end
	
	def customer_new
	 @customer = Customer.new
	 respond_to do |format|
      	format.html  {render 'customer_new'}
      	format.json { render json: @customer }
     end
	end
	
	def customer_create
		_post = params[:customer]
		customer = Customer.new
        customer[:first_name] = _post[:first_name]
        customer[:last_name] = _post[:last_name]
        customer[:phone] = _post[:phone]
        customer[:email] = _post[:email]
        customer[:billing_address] = _post[:billing_address]
        customer[:balance] = 0
        if customer.save
           redirect_to salesman_path
        else
           redirect_to salesman_path
        end
		
	end
end
