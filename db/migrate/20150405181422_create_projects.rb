class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.float :volume
      t.decimal :price_receive
      t.decimal :price_polish
      t.decimal :hourly_rate
      t.date :start_on
      t.date :end_on

      t.timestamps null: false
    end
  end
end
