class VersionController < ApplicationController
    def revert
        #delete the previous activity performed by the user
        activity = PublicActivity::Activity.find_by_id(params[:activity_id])
        if activity
            activity.destroy
        end
        if PaperTrail::Version.find_by_id(params[:id])
            @version = PaperTrail::Version.find_by_id(params[:id])
# if i am updating an invoice that has the previous state set to nil
#             if @version.item_type == "Invoice"
#                 if @version.reify.state == nil
#                     @version.reify.state = "sent"
#                 end
#             end
# return to previous version
            @version.reify.save!
        end
        redirect_to :back# , :notice => "Undid #{@version.event}."
    end
    
    def archive_customer
        customer = Customer.find_by_id(params[:id])
        customer.update_attribute(:active, false)
        redirect_to :back
    end
    
    def delete_user
        user = User.find_by_id(params[:id])
        user.destroy
        redirect_to :back
    end
end
