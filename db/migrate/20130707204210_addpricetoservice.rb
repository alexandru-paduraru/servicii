class Addpricetoservice < ActiveRecord::Migration
  def change
    add_column :services, :value, :integer
  end
end
