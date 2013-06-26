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
		pass = User.encrypt_password(object[:password])
		user.email = object[:email]
		user.password_salt = pass[:password_salt]
		user.password_hash = pass[:password_hash]
		user.first_name = object[:first_name]
		user.last_name = object[:last_name]
		user.type = 1
		
		respond_to do |format|
			if user.save 
				session[:user_id] = user[:id]
				format.html {render 'index'}
			else 
				format.html { render 'signup'}
			end
		end
		#redirect_to 'index'
	end
	
	def index
		render 'index'
	end
end
