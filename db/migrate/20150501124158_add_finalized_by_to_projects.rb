class AddFinalizedByToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :finalized_by, :integer
  end
end
