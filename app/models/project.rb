class Project < ActiveRecord::Base
  belongs_to :organization, dependent: :destroy
  has_many :tasks
  validates :title, presence: true, length: {minimum: 3}
  validates_uniqueness_of :title, :scope => :organization_id

  scope :by_organization, -> (organization_id) { where(organization_id: organization_id) }

  def self.create_default_project(organization_id)
    Project.create(
        {
            title: 'Default Project',
            description: 'The default project for tasks.',
            organization_id: organization_id
        })
  end
end
