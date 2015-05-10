class RenameProjectPriceColumns < ActiveRecord::Migration
  def change
    rename_column :projects, :price_receive, :sum_receive
    rename_column :projects, :price_polish, :sum_polish
  end
end
