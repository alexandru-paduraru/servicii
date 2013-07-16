class Changetypename < ActiveRecord::Migration
  def change
  	rename_column :actions, :type, :action_type
  end
end
