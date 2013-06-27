class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :date
      t.integer :number
      t.date :due_date
      t.float :amount
      t.float :current_balance
      t.references :company, index: true
      t.references :customer, index: true

      t.timestamps
    end
  end
end
