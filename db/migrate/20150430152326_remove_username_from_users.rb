class RemoveUsernameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :username if column_exists? :users, :username
  end

  def down
    p 'Irreversible migration. Not doing anything.'
  end
end
