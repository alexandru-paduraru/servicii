class AdminController < ApplicationController
	def new
		respond_to do |format|
			format.html {render 'signup'}
		end
	end
	
	def signup
		@user = User.new
	end

	def create
		# render text: params[:post].inspect
		pass = {}
		object = params[:user]
		@user = User.new
		@user.email = object[:email]
		@user.password = object[:password] 
		@user.first_name = object[:first_name]
		@user.last_name = object[:last_name]
		@user.job = 1
		
			if @user.save 
				session[:user_id] = @user[:id]
				redirect_to company_setup_path 
			else 
				render 'signup'
			end
		#redirect_to company_new_path
	end
	
	def company_new
		@company = Company.new 
	end
	
	def company_create
		@company = Company.new(params[:company])
		if @company.save
			@admin = current_user
			@admin.update_attribute(:company_id => @company[:id])
			redirect_to admin_path
		else render 'company_new'
		end
		
	end
	
	def index
		@users_details = []
		@users = User.all
		
		@users.each do |user|
			@user_details = User.details(user.id)
			@users_details.append(@user_details)
		end
		 render 'index'
	end
end
