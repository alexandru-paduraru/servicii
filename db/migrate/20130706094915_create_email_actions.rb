class CreateEmailActions < ActiveRecord::Migration
  def change
    create_table :email_actions do |t|
      t.date :sent_at
      t.date :viewed_at
      t.references :customer, index: true
      t.references :invoice, index: true

      t.timestamps
    end
  end
end
