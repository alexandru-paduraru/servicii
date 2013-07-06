class CollectorController < ApplicationController

	def index
	    @customers = Customer.search_collector_list(params[:search])
		render 'index'
	end

        
end
