class Adduseridtocustomer < ActiveRecord::Migration
  def change
      change_table :customers do |t|
      t.references :user, index: true 
    end
  end
end
