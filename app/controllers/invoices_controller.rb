class InvoicesController < ApplicationController

  def mark_payment
    @invoice = Invoice.find(params[:id])
    # TODO: update amount
  end

  def change_status
    @invoice = Invoice.find(params[:id])
    @invoice.update_attributes(:state => params[:state])
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
