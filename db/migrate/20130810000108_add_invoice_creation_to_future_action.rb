class AddInvoiceCreationToFutureAction < ActiveRecord::Migration
  def change
    add_column :future_actions, :invoice_creation, :boolean
  end
end
