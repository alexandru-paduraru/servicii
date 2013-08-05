class AddRecurringInvoiceIdToRecurringContactData < ActiveRecord::Migration
  def change
    add_column :recurring_contact_data, :recurring_invoice_id, :integer
  end
end
