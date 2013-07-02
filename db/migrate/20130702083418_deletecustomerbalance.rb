class Deletecustomerbalance < ActiveRecord::Migration
  def change
  remove_column :customers, :balance
  end
end
