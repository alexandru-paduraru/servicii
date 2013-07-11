class Modifycustomermodel < ActiveRecord::Migration
  def change
  	add_column :customers, :organization_name, :string
  	add_column :customers, :address1, :string
  	add_column :customers, :address2, :string
  	add_column :customers, :state, :string
  	add_column :customers, :city, :string
  	add_column :customers, :zip_code, :string
  	add_column :customers, :industry, :string
  	add_column :customers, :company_size, :string
  	remove_column :customers, :billing_address 
  end
end
