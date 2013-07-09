class Invoicehasservicemod < ActiveRecord::Migration
  def change
  	remove_column :invoice_has_services, :qty
  	remove_column :invoice_has_services, :float
  	add_column :invoice_has_services, :qty, :float
  end
end
