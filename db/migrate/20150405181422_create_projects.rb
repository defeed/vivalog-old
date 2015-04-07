class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.float :volume
      t.decimal :price
      t.date :date

      t.timestamps null: false
    end
  end
end
