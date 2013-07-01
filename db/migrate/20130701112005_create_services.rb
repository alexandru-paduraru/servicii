class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.references :company, index: true

      t.timestamps
    end
  end
end
