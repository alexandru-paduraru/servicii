class Addcompanyidtoemail < ActiveRecord::Migration
  def change
    change_table :email_actions do |t|
      t.references :company, index: true 
    end
  end
end
