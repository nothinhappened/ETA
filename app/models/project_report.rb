# This object runs a series of task reports for a given project
# It requires a project id, start time, and end time for initialization
class ProjectReport
  include ActiveModel::Model
  attr_accessor :id, :start_time, :end_time, :task_reports, :project_name, :time_spent_on_project, :time_allocated_to_project

  def run_report
    @time_spent_on_project = 0.0
    @task_reports = []
    @time_allocated_to_project = 0.0
    @project_name = Project.find(id).title
    #Find each task in project and create a task report for it.
    Task.from_project(id).each do |task|
      task = TaskReport.new(task_id: task.id, start_time: start_time, end_time: end_time)
      task.new_report
      @time_spent_on_project += task.task_data.time_on_task_total
      @time_allocated_to_project += task.allocated_task_time
      @task_reports.append(task)
    end
  end
end