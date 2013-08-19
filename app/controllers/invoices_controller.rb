class InvoicesController < ApplicationController

  def mark_payment
    @invoice = Invoice.find(params[:id])
    # TODO: update amount
  end

  def change_status
    @invoice = Invoice.find(params[:id])
    @invoice.update_attributes(:state => params[:state])
#saving the previous version before the status changed along with the activity
    activity = PublicActivity::Activity.all.last
    activity.pre_version_id = activity.trackable.versions.last.id
    activity.save!
    respond_to do |format|
      format.js
    end
  end

  def next_status
    invoice = Invoice.find(params[:id])
    invoice.next_status

    redirect_to "/customer_details/#{invoice.customer.id}"
  end
end
