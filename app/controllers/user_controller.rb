class UserController < ApplicationController
	def login
	  
	 respond_to do |format|
      	format.html  {render 'login'}
      	format.json { render json: @user }
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

#################### Employee ##########################
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
		@user.company_id = current_user.company_id
		
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
	
	def edit
		#@user = User.find(params[:id])
		@user = User.find(:first, :conditions => 'id='+ params[:id]) 
		if @user
			if @user.company_id == current_user.company_id
				@user
			else 
				redirect_to admin_path, :notice => "Error! User not available for your company"
			end	
		else 
				redirect_to admin_path, :notice => "Error! User not available for your company"
		end
	end
	
	def update
		@user = User.find(params[:id])
		_post = params[:user]
		ok = 0
		@user.email = _post[:email]
		@user.password = _post[:password]
		@user.first_name = _post[:first_name]
		@user.last_name = _post[:last_name]
		
		if @user.save
			@worksons = Workson.all(:conditions => { :user_id => params[:id] })
			@worksons.each do |job|
				job.destroy
			end
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
 				redirect_to admin_path, :notice => "Employee updated successfully"
 			else render text: "eroare la adaugarea job-ului"
 			end
		else
			render 'edit', :notice => "There was an error, please try again"
		end
	end
	
	def email
		respond_to do |format|
		 format.html{ render 'email'}
		end
	end
	
#################### End Employee ##########################
	
#################### Customer ##########################	
	
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
        customer[:company_id] = current_user[:company_id]
        if customer.save
           redirect_to salesman_path
        else
           redirect_to salesman_path
        end
		
	end
	
	def customers_import_export
	@error_at_import = []
		respond_to do |format|
		format.html {render 'customers_import_export'}
		end
	end
	
	def customer_import
	    @error_at_import = []
	    
	    if(params[:file])
	 		@error_at_import = Customer.import(params[:file], current_user)
	    end
	    
	    if @error_at_import != []
	 		redirect_to customers_import_export_path, :notice => "error"+@error_at_import.to_s
	 	else
	 	 	redirect_to customers_import_export_path, :notice => "Customers imported."
	 	end
	end
	
	def customer_export
	    @customers = Customer.all
		    respond_to do |format|
			    format.html {render 'customers_import_export'}
			    format.csv  {send_data Customer.to_csv(@customers) }
		    end
	end
	
#################### End Customer ##########################
end
