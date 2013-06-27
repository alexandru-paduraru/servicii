class UserController < ApplicationController
	def login
	  
	 respond_to do |format|
      	format.html  {render 'login'}
      	format.json { render json: @user }
      end
	end
	
	def create
		pass = {}
		_post = params[:user]
		user = User.new
		workson = Workson.new
		pass = User.encrypt_password(_post[:password])
		user.email = _post[:email]
		user.password_hash = pass[:password_hash]
		user.password_salt = pass[:password_salt]
		user.first_name = _post[:first_name]
		user.last_name = _post[:last_name]
		
	end
end
