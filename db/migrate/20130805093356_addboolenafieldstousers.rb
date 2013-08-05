class Addboolenafieldstousers < ActiveRecord::Migration
  def change
    add_column :users, :salesman, :boolean
    add_column :users, :accountant, :boolean
    add_column :users, :collector, :boolean
  end
end
