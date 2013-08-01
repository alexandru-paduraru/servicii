class VersionController < ApplicationController
    def revert
        #delete the previous activity performed by the user
        activity = PublicActivity::Activity.find(params[:activity_id])
        activity.destroy
    
        @version = PaperTrail::Version.find(params[:id])
        @version.reify.save!
        redirect_to :back# , :notice => "Undid #{@version.event}."
    end
    
    def archive_customer
        customer = Customer.find_by_id(params[:id])
        customer.update_attribute(:active, false)
        redirect_to :back
    end
end
