begin
class ChangeTimeForTaskFormat < ActiveRecord::Migration
  def change
    change_column :tasks, :task_time, :float
  end
end
end
