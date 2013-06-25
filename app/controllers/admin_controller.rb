class AdminController < ApplicationController
	def login
	  	
	  respond_to do |format|
      	format.html { render signup.html.erb }
      	format.json { render json: @admin }
      end
	end
	
	def signin
		
	end
end
