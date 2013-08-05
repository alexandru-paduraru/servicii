class CreateRecurringInvoices < ActiveRecord::Migration
  def change
    create_table :recurring_invoices do |t|
      t.boolean :sms_notification
      t.boolean :email_notification
      t.boolean :daily
      t.boolean :weekly
      t.boolean :monthly
      t.integer :invoice_id

      t.timestamps
    end
  end
end
