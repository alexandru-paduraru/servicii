class CreateFutureActions < ActiveRecord::Migration
  def change
    create_table :future_actions do |t|
      t.integer :invoice_id
      t.boolean :sms_notification
      t.boolean :email_notification
      t.integer :duration_type
      t.integer :starting_day
      t.integer :starting_week_day

      t.timestamps
    end
  end
end
