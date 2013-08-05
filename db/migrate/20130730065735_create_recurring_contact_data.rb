class CreateRecurringContactData < ActiveRecord::Migration
  def change
    create_table :recurring_contact_data do |t|
      t.string :sms_number
      t.string :sms_body
      t.string :email_to
      t.string :email_from
      t.text :email_body
      t.text :email_cc

      t.timestamps
    end
  end
end
