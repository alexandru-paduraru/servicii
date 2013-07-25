class Addindextoworkson < ActiveRecord::Migration
  def change
  remove_column :worksons, :user_id
      change_table :worksons do |t|
      t.references :user, index: true 
      end
  end
end
