class InvoicesController < ApplicationController

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
