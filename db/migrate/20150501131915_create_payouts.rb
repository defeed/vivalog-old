class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.string :work_type, null: false
      t.decimal :amount, null: false

      t.timestamps null: false
    end

    add_index :payouts, :user_id
    add_index :payouts, :project_id
  end
end
