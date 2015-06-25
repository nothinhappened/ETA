module UserTasksHelper
  def check_array_for_errors?(object_array)
    i = 0
    while i<object_array.size do
      if object_array[i].errors.any?
        return true
      end
      i += 1
    end
    false
  end

  def get_tasks_selected_array
    Task.get_tasks_associated_with_user(@user.id).compact.map do |task|
      [task.task_and_project_name, task.id]
    end
  end

  def get_tasks_unselected_array
    Task.get_tasks_unassociated_with_user(@user.id,current_user.organization_id).map { |task| [task.task_and_project_name, task.id]}.sort{|a,b| a[0] <=> b[0] }
  end

  def get_users_array
    User.where(:organization_id => current_user.organization_id).map { |user| [user.full_name, user.id.to_i] }.sort{|a,b| a[0] <=> b[0] }
  end

  # @param [String] description - a description string from a time_entries task
  # @return [String] description if the input has content, a string alerting that the user has not entered a description otherwise
  def add_message_if_empty(description)
    if description.empty?
      '<i>No description has been entered.</i>'.html_safe
    else
      description
    end
  end
end