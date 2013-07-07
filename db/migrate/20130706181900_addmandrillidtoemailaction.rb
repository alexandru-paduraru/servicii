class Addmandrillidtoemailaction < ActiveRecord::Migration
  def change
  	add_column :email_actions, :mandrill_id, :string
  end
end
