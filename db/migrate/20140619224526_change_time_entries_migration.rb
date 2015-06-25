class ChangeTimeEntriesMigration < ActiveRecord::Migration
  def change
      remove_column :time_entries, :duration
      add_column :time_entries, :duration, :time
  		#change_column :time_entries, :duration, 'time USING CAST(duration AS time)'
  end
end
