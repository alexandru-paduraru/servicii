class Addtextnotetoaction < ActiveRecord::Migration
  def change
  	remove_column :actions, :mandrill_id
  	add_column :actions, :type, :string
  	add_column :actions, :text_note, :text
  end
  
end
