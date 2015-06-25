module TimeEntriesHelper	
	# Get an array of one week worth of days starting
	# the 'from_date', where each element is true iff the day is unlocked.
	def get_weekdays_unlocked(from_date)
		weekdays = []		
		7.times do |num|		
			weekdays << UnlockedTime.is_within_unlocked_period((from_date + num.days).to_date,current_user.organization_id)
		end    
		weekdays
	end

	# Get an array of one week worth of days starting from the 'from_date'
	def get_weekdays(from_date)
		weekdays = []
		7.times do |num|
			weekdays << (from_date + num.days)
		end
		weekdays
	end

	def get_blank_timesheet_table(current_user, start_date)
		user_tasks = Task.get_unarchived_tasks_for_user(current_user.id)
		projects = user_tasks.group(:project_id, 'tasks.id').order(:project_id)
		
		weekdays =  get_weekdays(start_date)
		weekdays_unlocked = get_weekdays_unlocked(start_date)

		timesheet = {}
		projects.each do |project|
			# Form the array of time_entries
			entries = {}
			user_tasks.each do |task|
				# skip adding tasks not apart of the project
				next if(task.project_id != project.project_id)					

				# Create the week_timesheet array.
				week_timesheet = {}
				weekdays.each_with_index do |day,day_index|
					# append the entry to the week_timesheet
					week_timesheet[day.day] = {
						task_id: 'task_' + task.id.to_s,
						day_id: 'day_' + (day_index+1).to_s,
						description_id: 'description_' + (day_index+1).to_s,
						value: '',
						description: '',
						is_unlocked: weekdays_unlocked[day_index]
					}
				end			
							
				entries[task.id]= {
					task_name: task.name,
					task: task,
					week_timesheet: week_timesheet
				}
			end

			timesheet[project.project_id] = {
				project_title: Project.find(project.project_id).title.to_s,
				entries: entries
			}
		end
		timesheet
	end


#	timesheet = {
#		1:{
#			2:{
#				task_name: task_2_project_1,
#				week_timesheet: {
#					7:{
#						task_id: task_1,
#						day_id: day_1,
#						description_id: description_1,
#						value: '08:05',
#						description:"desription for monday"
#					},
#					... all seven days of the weeking staring from the 7th
#				}
#			},
#			... more tasks
#		},
#		... more projects
#	}
	def get_timesheet(current_user,start_date)			
		timesheet = get_blank_timesheet_table(current_user,start_date)
		
		# fill in the timesheet with all the information from the user_entries query		
		user_entries = TimeEntry.get_unarchived_user_entries_in_date_range(current_user.id, start_date, start_date + 6.days)
    user_entries.each do |entry|
			#timesheet[entry.project_id][:project_title] = entry.project_title
			day = timesheet[entry.project_id][:entries][entry.task_id][:week_timesheet][entry.start_time.to_date.day]
			day[:value] = Duration.server_to_client_duration(entry.duration)
			day[:description] = entry.description			
		end

		timesheet
	end

	#entries = [
   #  {
   #    task_name :"name", 
   #    week_timesheet: [
   #      {
   #			id: "task_109",
   #			day_index: "day_1",
   #			description_id: "description_1",
   #			value: "day_value",
   #			description: "comment 1",
   #			is_unlocked: true
   #		 },
   #      {id: "task_109", day_index: "day_2", description_id: "description_2", value: ""			 , description: "comment 2"},
   #      {id: "task_109", day_index: "day_3", description_id: "description_3", value: "day_value", description: "comment 3"},
   #      {id: "task_109", day_index: "day_4", description_id: "description_4", value: ""			 , description: "comment 4"},
   #      {id: "task_109", day_index: "day_5", description_id: "description_5", value: "day_value", description: "comment 5"},
   #      {id: "task_109", day_index: "day_6", description_id: "description_6", value: ""			 , description: "comment 6"},
   #      {id: "task_109", day_index: "day_7", description_id: "description_7", value: "day_value", description: "comment 7"},
   #    ]
   #  }
   #},
	def get_time_entries_array(current_user,start_date)		
		user_time_entries = TimeEntry.get_user_time_entries_starting(current_user.id,start_date,6)
		user_tasks = Task.get_unarchived_tasks_for_user(current_user.id)

		weekdays =  get_weekdays(start_date)
		weekdays_unlocked = get_weekdays_unlocked(start_date)

	
		# Form the array of time_entries
		entries = []
		user_tasks.each do |task|
			# Create the week_timesheet array.
			week_timesheet = []

			weekdays.each_with_index do |day,day_index|
				#expensive as shit?							
				#entry_value = user_time_entries.where(task_id:task.id, start_time: TimeEntry.get_db_date_format(day))
				
				entry_value = user_time_entries.by_task_and_day(task.id,TimeEntry.get_db_date_format(day))				

				# Let value be "" unless there is a time already assigned	
				if entry_value.any?
					value = Duration.server_to_client_duration(entry_value.first.duration)
					comment = entry_value.first.description
				end

				# append the entry to the week_timesheet
				week_timesheet << {
					task_id: 'task_' + task.id.to_s,
					day_id: 'day_' + (day_index+1).to_s,
					description_id: "description_" + (day_index+1).to_s,
					value: value.to_s,
					description: comment.to_s,
					is_unlocked: weekdays_unlocked[day_index]
				}
			end			
						
			entries << {
				task_name: task.name,
        		task: task,
				week_timesheet: week_timesheet
			}
		end
    entries
  end
	  
end
