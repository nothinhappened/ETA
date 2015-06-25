module TasksHelper
  def get_users_selected_array
    User.get_users_associated_with_task(@task.id).map do |user|
      [user.full_name, user.id]
    end
  end

  def get_users_unselected_array
    User.get_users_unassociated_with_task(@task.id,current_user.organization_id).map { |user| [user.full_name, user.id]}
  end

  def get_users_array
    User.where(:organization_id => current_user.organization_id).map { |user| [user.full_name, user.id] }
  end
end