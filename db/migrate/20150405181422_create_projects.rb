class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.float :volume
      t.decimal :rate_receive
      t.decimal :rate_polish
      t.decimal :hourly_rate
      t.date :date

      t.timestamps null: false
    end
  end
end
