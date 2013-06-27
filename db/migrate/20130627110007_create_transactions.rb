class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :date
      t.string :type
      t.integer :number
      t.float :amount
      t.references :invoice, index: true
      t.references :company, index: true
      t.references :customer, index: true

      t.timestamps
    end
  end
end
