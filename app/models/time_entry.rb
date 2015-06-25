class TimeEntry < ActiveRecord::Base
  belongs_to :organization#, class_name:'Organizations', foreign_key: => 'organization_id'
  belongs_to :user			#, class_name:'Users', foreign_key: => 'user_id'
  belongs_to :task			#, class_name:'Tasks', foreign_key: => 'task_id'

  # validations of fields
  validates :user_id, presence: true
  validates :organization_id, presence: true
  validates :task_id, presence: true
  validates :start_time, presence: true
  validates :duration,presence: true
  validates :description,
            length: {
                maximum:500,
                too_long: '%{count} characters is the maximum allowed'
            }

  scope :by_task_and_day, -> (task_id, day) {where(task_id: task_id, start_time: day)}
  scope :between, -> (start_week, end_week) {where('start_time BETWEEN ? and ?',start_week, end_week)}
  scope :by_task, -> (task_id) {(where(task_id: task_id))}
  scope :by_user, -> (user_id) {(where(user_id: user_id))}


  # TODO: I'd rather not do such a direct query, but I'm having a lot of trouble using the built-in activeRecord query methods to do what I want.
  # @param [Integer] current_user_id - The id for which we want the time_entries for
  # @param [Date] start_date - starting date to get entries for
  # @param [Date] end_date - The ending date. Should come after the start_date
  # @return [time_entry[]] - time_entries for users between start_date and end_date
  def self.get_unarchived_user_entries_in_date_range(current_user_id, start_date,end_date)
    find_by_sql(
        ["SELECT
          projects.id as project_id,
          projects.title as project_title,
          tasks.id as task_id,
          tasks.name as task_name,
          tasks.archived as task_archived,
          T.id,
          T.start_time,
          T.duration,
          T.user_id,
          T.description
        FROM time_entries as T
        INNER JOIN tasks ON T.task_id = tasks.id
        INNER JOIN projects ON tasks.project_id = projects.id
        WHERE
          T.user_id = :user_id AND
          (T.start_time BETWEEN :start_week AND :end_week) AND
          tasks.archived = 'f'
        ORDER BY project_id,task_id",
         {
             user_id: current_user_id,
             start_week: get_db_date_format(start_date),
             end_week: get_db_date_format(end_date)
         }])
  end

  def get_duration
    Duration.new(duration)
  end

  # user_id
  # start_date - a date object
  # num_days - the number of days to retrieve from start_date
  def self.get_user_time_entries_starting(user_id,start_date,num_days)
    start_week = get_db_date_format(start_date)
    end_week = get_db_date_format(start_date + num_days.days)
    User.find(user_id).time_entries.between(start_week,end_week)
  end

  # convert from time format to database start_time format
  # t: Time object || Date object || DateTime object?
  def self.get_db_date_format(t)
    t.strftime('%Y-%m-%d')
  end

  # task: activeRecored object
  # day: Date object || Time object
  # Return: true if the entry was saved, false otherwise
  def self.save_time_entry(task_id, day, new_duration, new_comment, user_time_entries,current_user)
    # don't save the entry, if it is in an locked period
    return false unless UnlockedTime.is_within_unlocked_period(day.to_date, current_user.organization_id)

    new_duration = Duration.new(new_duration)
    entry = user_time_entries.by_task_and_day(task_id,get_db_date_format(day))

    if entry.any?
      overwrite_existing_entry(entry.first, new_comment, new_duration)
    else
      create_new_entry(current_user, day, new_comment, new_duration, task_id)
    end
  end

  # @param [user] user - the user which the time_entry is being created for
  # @param [Object] day
  # @param [String] new_comment -The comment for the newly created timeentry object
  # @param [Object] new_duration - the duration in client format
  # @param [Integer] task_id - the id for the task object the timeentry is being created for
  # @return [Boolean] false if the object was not created successfully
  def self.create_new_entry(user, day, new_comment, new_duration, task_id)
    return false if new_duration.contains_nil? || new_duration.is_zero_duration? #Do nothing if duration is empty
    #create the new entry, and return true if sucessful
    not create({
                   start_time: get_db_date_format(day),
                   duration: new_duration.server_duration,
                   description: new_comment,
                   organization_id: user.organization_id,
                   user_id: user.id,
                   task_id: task_id
               }).errors.any?
  end

  # @param [time_entry] entry - the existing entry object to overwrite
  # @param [String] new_comment - the new comment value to be written
  # @param [Object] new_duration - duration in client format
  # @return [Boolean] true if overwrite was successful, false if nothing changed or overwrite was unsucessful
  def self.overwrite_existing_entry(entry, new_comment, new_duration)
    if new_duration.contains_nil?
      # invalid input.. don't change anything
      false
    elsif new_duration.is_zero_duration?
      !!entry.destroy
    else
      entry.duration, entry.description = new_duration.server_duration, new_comment
      entry.changed? and entry.save
    end
  end

  def self.save_all_time_entries(params,current_user)
    user_tasks = Task.get_unarchived_tasks_for_user(current_user.id)
    # Select all the relevant time entries for this one week period
    user_time_entries = get_user_time_entries_starting(current_user.id, params[:start_date].to_date, 6)

    # Create an array of all the dates for this week, so that we can iterate over them
    weekdays = []
    7.times {|num| weekdays << (params[:start_date].to_date + num.days) }

    # Iterate through each task and check if we need to either
    # create, destroy, or update a time entry in the DB
    changed_flag = false
    user_tasks.each do |task|
      weekdays.each_with_index do |day, day_index|
        duration = params['task_' + task.id.to_s]['day_'+ (day_index+1).to_s]
        comment = params['task_' + task.id.to_s]['description_'+ (day_index+1).to_s]
        changed_flag |= save_time_entry(task.id, day, duration, comment, user_time_entries, current_user)
      end
    end
    changed_flag
  end
end
