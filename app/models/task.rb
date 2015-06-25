class Task < ActiveRecord::Base
  belongs_to :organization
  belongs_to :project
  has_many :time_entries
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks
  validates :name, presence: true, length: {minimum: 3}
  validates :project_id, presence: true
  validates_uniqueness_of :name, :scope => :organization_id
  validate :validate_task_belongs_to_organization
  validates :task_time, numericality: {greater_than_or_equal_to: 0}, :allow_blank => true
  scope :by_organization, -> (organization_id) { where(organization_id: organization_id) }
  scope :from_project, -> (project_id) {where(project_id: project_id)}

  def validate_task_belongs_to_organization
    errors.add(:project_id, ' is not from your organization.') unless organization.id == project.organization.id
  end

  scope :not_archived, -> {where(archived:false)}

  def self.get_tasks_associated_with_user(user_id)
    Task.find_by_sql(['SELECT "tasks".* from "tasks"
      INNER JOIN "user_tasks" ON "tasks"."id" = "user_tasks"."task_id"
      WHERE
        "tasks"."archived" = "f" AND
        "user_tasks"."user_id" = :user_id', {:user_id => user_id}])
  end

  def self.get_tasks_unassociated_with_user(user_id, organization_id)
    Task.find_by_sql(['SELECT "tasks".* from "tasks"
      WHERE
        "tasks"."archived" = "f" AND
        "tasks"."organization_id" = :organization_id AND
        "tasks"."id" not in (
          SELECT "tasks"."id" from "tasks"
          INNER JOIN "user_tasks" ON "tasks"."id" = "user_tasks"."task_id"
          WHERE
            "user_tasks"."user_id" = :user_id)', {:user_id => user_id, :organization_id => organization_id}
    ])
  end
  

  def time_spent_on_task
    result = 0.0
    TimeEntry.by_task(id).each do |entry|
      result += entry.duration.hour + Float(entry.duration.min)/60 + (entry.duration.sec)*24
    end
    #still having errors without explicit return
    result
  end

  def percent_done
    if task_time.nil? || task_time.zero?
      0
    else
      (time_spent_on_task/task_time*100).round(2)
    end

  end

  def task_and_project_name
    project.title + ' - ' + name
  end

  def self.get_unarchived_tasks_for_user(user_id)
    return User.find(user_id).tasks.not_archived
    #return User.where(id: user_id).first.tasks.where(archived: false)
  end

  def archive
    self.update(:archived => true)
  end

  def unarchive
    self.update(:archived => false)
  end

  def archived?
    archived
  end
end
