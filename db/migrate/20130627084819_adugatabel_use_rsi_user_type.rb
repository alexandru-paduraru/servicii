class AdugatabelUseRsiUserType < ActiveRecord::Migration
  def change
   remove_column :users, :job
  end
  
end
