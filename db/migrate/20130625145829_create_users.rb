class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_salt
      t.string :password_hash
      t.integer :user_type
      t.integer :company_id

      t.timestamps
    end
  end
end
