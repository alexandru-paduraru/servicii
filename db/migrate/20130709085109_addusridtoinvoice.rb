class Addusridtoinvoice < ActiveRecord::Migration
  def change
    change_table :invoices do |t|
      t.references :user, index: true 
    end
  end
end
