class UserController < ApplicationController
	def login
	  
	 respond_to do |format|
      	format.html  {render 'login'}
      	format.json { render json: @user }
      end
	end
	
	def signin
		
	end
end
