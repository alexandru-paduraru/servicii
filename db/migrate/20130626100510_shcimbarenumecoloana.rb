class Shcimbarenumecoloana < ActiveRecord::Migration
  def change
  	rename_column :users, :type, :job
  end
end
