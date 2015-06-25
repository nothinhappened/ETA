class User < ActiveRecord::Base
  belongs_to :organization
  has_many :user_tasks, dependent: :destroy
  has_many :tasks, through: :user_tasks
  has_many :time_entries

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  before_save { self.email = email.downcase}
  before_create :create_remember_token

  has_secure_password
  validates :first_name,length: {maximum: 50}
  validates :last_name, length: {maximum: 50}

  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  validates :user_type, presence: true, on: :create
  validate  :user_type_is_within_correct_range , on: :create

  validates :password,
            presence: true,
            length: {minimum: 6 },
            on: :create

  scope :by_organization, -> (organization_id) { where(organization_id: organization_id) }

  def full_name
    first_name + ' ' + last_name
  end

  def user_type_is_within_correct_range
    unless user_type.present? && user_type >= 0 && user_type < 3
      errors.add(:user_type, 'User type must be between 0 and 2')
    end
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.get_users_associated_with_task(task_id)
    User.find_by_sql(['SELECT "users".* from "users"
      INNER JOIN "user_tasks" ON "users"."id" = "user_tasks"."user_id"
      WHERE
        "users"."archived" = FALSE AND
        "user_tasks"."task_id" = :task_id', {:task_id => task_id}])
  end

  def self.get_users_unassociated_with_task(task_id, organization_id)
    User.find_by_sql(['SELECT "users".* from "users"
      WHERE
        "users"."archived" = FALSE AND
        "users"."organization_id" = :organization_id AND
        "users"."id" not in(
          SELECT "users"."id" from "users"
          INNER JOIN "user_tasks" ON "users"."id" = "user_tasks"."user_id"
          WHERE
          "user_tasks"."task_id" = :task_id)', {:task_id => task_id, :organization_id => organization_id}])
  end

  def archived?
    archived
  end

  def archive
    self.update(:archived=>true)
  end

  def unarchive
    self.update(:archived=>false)
  end

  def self.user_types
    ['Inactive','Standard User','Administrator']
  end

  def user_type_string
    return User.user_types[0] if archived?
    User.user_types[user_type]
  end

  def update_user(user_params)
    if user_params[:user_type] == '0'
      user_params[:user_type] = user_type
      archive
    end
    update_attributes(user_params)
  end

  private
  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end

end

