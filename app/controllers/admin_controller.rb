class AdminController < ApplicationController
	def new
		respond_to do |format|
			format.html {render 'signup'}
		end
	end
	
	def create
	# render text: params[:post].inspect
	end
end
