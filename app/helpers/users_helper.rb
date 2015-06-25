module UsersHelper
	def gravatar_for(user,size=120)
		g_id = Digest::MD5::hexdigest(user.email.downcase)
		g_url = "https://secure.gravatar.com/avatar/#{g_id}"
		image_tag(g_url,alt: user.email, class: 'gravatar', size: size)
  end

  # @param [Integer] task_id - a task_id for the task object whose time is needed
  # @return [Integer] total_time - the total time which @user has worked on @task
  def get_total_time_by_task(task_id)
    total_time = 0.0
    TimeEntry.by_task(task_id).by_user(@user.id).each do |time_entry|
      total_time += time_entry.get_duration.to_i
    end
    total_time.round(2)
  end
end