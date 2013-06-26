class AdminController < ApplicationController
	def new
		respond_to do |format|
			format.html {render 'signup'}
		end
	end
	
	def create
	# render text: params[:post].inspect
	@admin = User.new(admin_params)
 
	@admin.save
	redirect_to @post
	end
end
