class UserTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  has_many :time_entries, through: :user

  validates :user_id, presence: true
  validates :task_id, presence: true
  validates_uniqueness_of :user_id, :scope => :task_id

  scope :by_user, -> (user_id) { where(user_id: user_id) }
  scope :by_task, -> (task_id) { where(task_id: task_id) }
end
