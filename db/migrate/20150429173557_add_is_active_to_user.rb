class AddIsActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_active, :boolean, null: false, default: false
  end
end
