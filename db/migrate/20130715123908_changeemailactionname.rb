class Changeemailactionname < ActiveRecord::Migration
  def change
  	rename_table :email_actions, :actions
  end
end
