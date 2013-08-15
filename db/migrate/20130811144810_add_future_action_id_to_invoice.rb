class AddFutureActionIdToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :future_action_id, :integer
  end
end
