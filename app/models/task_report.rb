

class TaskReport
  include ActiveModel::Model
  attr_accessor :task_id, :start_time, :end_time, :users, :result, :task_name, :task_data, :allocated_task_time

  def new_report
    @task_name = Task.find(task_id).name
    @task_data = OpenStruct.new
    @task_data.list_of_users_and_data = []
    @task_data.task_id = task_id
    @allocated_task_time = Task.find(task_id).task_time
    @task_data.time_on_task_total = 0.0

    #Find all users assigned to task and grab their time entries
    #Task.users.each do |user|
    UserTask.by_task(task_id).find_each do |user_task|
      temp_user_blob = OpenStruct.new
      temp_user_blob.total_time = 0.0
      temp_user_blob.comment_time = []
      temp_user_blob.duration = []
      temp_user_blob.name = user_task.user.full_name
      TimeEntry.where('task_id = ? AND start_time >= ? AND start_time < ? AND user_id = ?', task_id, start_time.to_time - 1.day, end_time, user_task.user.id).find_each do |entry|
        time_temp = entry.duration.hour + entry.duration.min/60.0 + entry.duration.sec*24
        temp_user_blob.comment_time.append([entry.description, time_temp])
        temp_user_blob.duration.append(time_temp)
        temp_user_blob.total_time += time_temp
        @task_data.time_on_task_total += time_temp
      end
      @task_data.list_of_users_and_data.append(temp_user_blob)
    end
  end
end

