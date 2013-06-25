class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :address
      t.string :zip_code
      t.string :city
      t.string :county
      t.string :country

      t.timestamps
    end
  end
end
