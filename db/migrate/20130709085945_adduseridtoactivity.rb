class Adduseridtoactivity < ActiveRecord::Migration
  def change
  	change_table :email_actions do |t|
      t.references :user, index: true 
    end
  end
end
