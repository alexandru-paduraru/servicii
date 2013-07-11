class Addaccountnumber < ActiveRecord::Migration
  def change
    add_column :customers, :account, :string
  end
end
