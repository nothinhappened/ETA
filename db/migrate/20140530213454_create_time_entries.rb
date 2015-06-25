class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|      
      t.date :start_time

      # in minutes? or hours?
      # TODO, Should this be a float or double?
      t.integer :duration  

      # id references
      t.integer :organization_id      
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end

    add_index :time_entries, [:user_id, :organization_id, :task_id]
    add_index :time_entries, [:start_time]
  end
end
