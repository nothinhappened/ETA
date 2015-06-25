class DefaultTaskTime < ActiveRecord::Migration
  def change
    change_column :tasks, :task_time, :float, :default => 0
  end
end
