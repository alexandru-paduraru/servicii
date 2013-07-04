class Addsendtocollector < ActiveRecord::Migration
  def change
    add_column :customers, :sent_to_collector, :boolean
  end
end
