class AddArchivedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :archived, :boolean, :null => false, :default => false
  end
end
