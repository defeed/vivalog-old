class AddSqmToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :sqm, :decimal
  end
end
