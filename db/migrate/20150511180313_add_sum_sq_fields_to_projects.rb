class AddSumSqFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sum_sq_receive, :decimal
    add_column :projects, :sum_sq_polish, :decimal
  end
end
