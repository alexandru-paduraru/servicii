class AddPaidAmountToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :paid_amount, :float
  end
end
