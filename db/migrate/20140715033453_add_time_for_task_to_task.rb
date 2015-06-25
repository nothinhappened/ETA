begin
class AddTimeForTaskToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_time, :integer
  end
end
end
