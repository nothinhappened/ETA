class AddDescriptionToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :description, :text, {null: false, default:""}
  end
end
