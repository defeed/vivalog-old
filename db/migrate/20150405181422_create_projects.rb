class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.float :volume
      t.decimal :price_receive
      t.decimal :price_polish
      t.decimal :price_other
      t.date :date

      t.timestamps null: false
    end
  end
end
