class CollectorController < ApplicationController

	def index
	    @customers = Customer.search(params[:search])
		render 'index'
	end

        
end
