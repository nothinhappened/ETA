class UserReport
  include ActiveModel::Model
  attr_accessor :user_id, :start_time, :end_time, :tasks, :result, :user_name

  def run_report
    @user_name = User.find(user_id).full_name
    temp = TimeEntry.joins(:task).where(:user_id => user_id).group('task_id')
    @tasks = Hash.new
    temp.each do |task|
      @tasks[task.task.name] = Float(0)
    end
    @result = 0.0
    report = TimeEntry.joins(:task).where('user_id = ? AND start_time >= ? AND start_time < ?', user_id, start_time.to_time - 1.day, end_time)
    report.each do |entry|
      @tasks[entry.task.name] += entry.duration.hour + entry.duration.min/60.0 + entry.duration.sec*24
      @result +=  entry.duration.hour + entry.duration.min/60.0 + entry.duration.sec*24
    end
  end
end

