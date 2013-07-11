

class UserController < ApplicationController
require 'mandrill'    
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
		
		@users_details = []
			@users = User.all
			
			@users.each do |user|
				@user_details = User.details(user.id)
				@users_details.append(@user_details)
			end

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
 			else redirect_to admin_path, :notice => "Employee was created! Info: you didn't choose any job for your employee, you can do this by editing your employee from the bottom list!"
 			end
 		else 
 			render 'admin/index'
		end
	end
	
	def edit
		#@user = User.find(params[:id])
		@user = User.find(:first, :conditions => 'id='+ params[:id]) 
		if @user
			if @user.company_id == current_user.company_id
				@user
			else 
				redirect_to admin_path, :alert => "Error! User not available for your company"
			end	
		else 
				redirect_to admin_path, :alert => "Error! User not available for your company"
		end
	end
	
	def update
		@user = User.find_by_id(params[:id])
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
 			else redirect_to admin_path, :notice => "Employee was updated! Info: you didn't choose any job for your employee, you can do this by editing your employee from the bottom list!"
 			end
		else
			render 'edit', :alert => "There was an error, please try again"
		end
	end
	
	
	
#################### End Employee ##########################
	
#################### User actions #######################	
	def send_email
		m = Mandrill::API.new
		message = {
		 :subject=> "Hello from the Mandrill API",
		 :from_name=> "Your name",
		 :text=>"Hi message, how are you?",
		 :to=>[
		   {
		     :email=> "axelut@gmail.com",
		     :name=> "Recipient1"
		   }
		 ],
		 :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",
		 :from_email=>"admin@mandrill.com"
		}
		sending = m.messages.send message
		puts sending
	end
	
################### End User actions #####################
	
#################### Customer ##########################	
	
	def customer_new
	 @customer = Customer.new
	end
	
	def customer_create
		@customer = Customer.new
		_post = params[:customer]
		@customer = Customer.new(:first_name => _post[:first_name], :last_name => _post[:last_name],:phone => _post[:phone], :email => _post[:email], :address1 => _post[:address1], :address2 => _post[:address2] , :organization_name => _post[:organization_name], :state => _post[:state], :city => _post[:city], :zip_code => _post[:zip_code])
#         @customer[:first_name] = _post[:first_name]
#         @customer[:last_name] = _post[:last_name]
#         @customer[:phone] = _post[:phone]
#         @customer[:email] = _post[:email]
#         @customer[:address1] = _post[:address1]
#         @customer[:address2] = _post[:address2]
        @customer[:company_id] = current_user[:company_id]
        @customer[:sent_to_collector] = false
        @customer[:active] = true
        @customer[:account] = Customer.generate_number
        @customer[:user_id] = current_user.id
        if @customer.save
           redirect_to customers_path
        else
           render 'customer_new'
        end
		
	end
	
	def customers_import_export
	    @errors = []
		respond_to do |format|
		format.html {render 'customers_import_export'}
		end
	end
	
	def customer_import
        @errors = []
	    
	    if(params[:file])
	 		@errors = Customer.import(params[:file], current_user)
	       
		    if @errors != []
		        string = ""
		        @errors.each do |error|
		        string += "Row " + error[:row].to_s+ ": " + error [:message] + "\n"
		        end
		 		render 'customers_import_export'
		 	else
		 	 	redirect_to customers_import_export_path, :notice => "Customers imported."
		 	end
		else #if no file is selected
			redirect_to customers_import_export_path, :alert => "Choose a file!"

		end
	end
	
	def customer_export
	    @customers = Customer.all
		    respond_to do |format|
			    format.html {render 'customers_import_export'}
			    format.csv  {send_data Customer.to_csv(@customers) }
		    end
	end
	
	def send_to_collector
		customer_id = params[:customer_id]
		customer = Customer.find_by_id(customer_id)
				
		if customer.update_attribute(:sent_to_collector, true)
			redirect_to customer_details_path(:customer_id => customer_id), :notice => "Success! Sent to collector."
		else
		    redirect_to customer_details_path(:customer_id => customer_id), :alert => "Error! Couldn't send to collector."
		end
	end
	

#################### End Customer ##########################

end
