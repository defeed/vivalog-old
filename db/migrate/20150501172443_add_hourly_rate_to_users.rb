class AddHourlyRateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hourly_rate, :decimal
  end
end
