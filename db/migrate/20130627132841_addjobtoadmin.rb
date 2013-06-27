class Addjobtoadmin < ActiveRecord::Migration
  def change
  	add_column :users, :job, :integer 
  end
end
