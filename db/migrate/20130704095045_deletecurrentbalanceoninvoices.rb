class Deletecurrentbalanceoninvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :current_balance
  end
end
