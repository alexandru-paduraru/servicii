class Addinactivecolumntocustomer < ActiveRecord::Migration
  def change
    add_column :customers, :active, :boolean
  end
end
