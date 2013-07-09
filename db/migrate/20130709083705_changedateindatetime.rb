class Changedateindatetime < ActiveRecord::Migration
  def change
  	change_column :email_actions, :sent_at, :datetime
  	change_column :email_actions, :viewed_at, :datetime
  end
end
