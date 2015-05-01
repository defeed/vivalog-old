class AddFinalizedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :finalized_at, :datetime
  end
end
