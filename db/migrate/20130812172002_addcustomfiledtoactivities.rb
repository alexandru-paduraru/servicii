class Addcustomfiledtoactivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.integer :pre_version_id
    end
  end
end
