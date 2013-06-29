class AdminController < ApplicationController
	def new
		respond_to do |format|
			format.html {render 'signup'}
		end
	end
	
	def create
		# render text: params[:post].inspect
		pass = {}
		object = params[:admin]
		user = User.new
		user.email = object[:email]
		user.password = object[:password] 
		user.first_name = object[:first_name]
		user.last_name = object[:last_name]
		user.job = 1
		
			if user.save 
				session[:user_id] = user[:id]
				redirect_to admin_path
			else 
				render text: 'eroare la inregistrare'
			end
		#redirect_to 'index'
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
