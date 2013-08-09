class AdminController < ApplicationController
	def new
		respond_to do |format|
			format.html {render 'signup'}
		end
	end
	
	
	
########### Company ###################
	def company_new
		@company = Company.new 
	end
	
	def company_create
		@company = Company.new(params[:company])
		if @company.save
			@admin = current_user
			@admin.update_attribute(:company_id, @company[:id])
			redirect_to admin_path
		else render 'company_new'
		end
	end
	
	def company_edit
		if current_user[:company_id] == params[:id].to_i
			@company = Company.find_by_id(params[:id])
		else
			redirect_to admin_path
		end
	end
	
	def company_update
		@company = Company.find_by_id(params[:id])
		 if @company.update_attributes(params[:company])
 		 	redirect_to admin_path, :notice => "Company updated successfully"
 		else 
			render 'company_edit'
 		end
	end
############ End Company ###############
	def index
	    _company_users_id = User.all.where(:company_id => current_user.company_id).select(:id)
	    @activities = PublicActivity::Activity.order('created_at desc').where(owner_id: _company_users_id) 
		@user = User.new
		@users_details = []
		@users = User.index_by_company(current_user.company_id)
		
		@customers = Customer.index(current_user.company_id)
		@invoices = Invoice.index(current_user.company_id)
		@actions = Action.index(current_user.company_id)
		
		@users.each do |user|
			@user_details = User.details(user.id)
			@users_details.append(@user_details)
		end
		 render 'index'
	end
	
	def employees_settings
	   @users_details = []
	   @users = User.index_by_company(current_user.company_id)
	   @users.each do |user|
	       @user_details = User.details(user.id)
	       @users_details.append(@user_details)
	   end
	end
end
