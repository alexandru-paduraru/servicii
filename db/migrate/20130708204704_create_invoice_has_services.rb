class CreateInvoiceHasServices < ActiveRecord::Migration
  def change
    create_table :invoice_has_services do |t|
      t.string :qty
      t.string :float
      t.references :invoice, index: true
      t.references :service, index: true

      t.timestamps
    end
  end
end
