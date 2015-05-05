class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :project_id, null: false
      t.integer :user_id, null: false
      t.date :worked_on, null: false
      t.decimal :coefficient
      t.integer :workers
      t.string :work_type, null: false
      t.string :billing_type
      t.decimal :hours
      t.decimal :hourly_rate
      t.decimal :daily_rate
      t.decimal :project_rate
      t.text :comment
      t.datetime :finalized_at
      t.integer :finalized_by

      t.timestamps null: false
    end
  end
end
