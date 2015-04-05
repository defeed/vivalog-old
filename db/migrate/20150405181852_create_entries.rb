class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :project_id
      t.integer :user_id
      t.date :worked_on
      t.decimal :coefficient, null: false, default: 1
      t.integer :workers
      t.string :work_type

      t.timestamps null: false
    end
  end
end
