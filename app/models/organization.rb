class Organization < ActiveRecord::Base
	has_many :time_entries
  has_many :projects
	has_many :users
	has_many :tasks
	has_many :unlocked_times

  validates :organization_name,
            presence: true

  accepts_nested_attributes_for :users
end
