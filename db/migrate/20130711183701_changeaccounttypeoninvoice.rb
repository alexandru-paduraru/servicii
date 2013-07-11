class Changeaccounttypeoninvoice < ActiveRecord::Migration
  def change
  	change_column :invoices, :number, :string
  end
end
