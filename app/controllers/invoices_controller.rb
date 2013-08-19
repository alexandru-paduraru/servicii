class InvoicesController < ApplicationController

  def show
    invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.json { render :json => invoice.to_json(:include => [:customer, :company]) }
    end
  end

  def mark_payment
    @invoice = Invoice.find(params[:id])

    # TODO: update amount
    @invoice.update_attributes(:paid_amount => params[:amount])
    if @invoice.paid_amount < @invoice.amount
      @invoice.partial!
    elsif @invoice.paid_amount.to_f == @invoice.amount.to_f
      @invoice.paid!
    end

    respond_to do |format|
      format.js
    end
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

  def undo
    @invoice = Invoice.find(params[:id])

    @invoice.undo_payment!

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
