class UnlockedTime < ActiveRecord::Base
	belongs_to :organization
	
	validates :start_time		, presence: true
  	validates :end_time			, presence: true
  	validates :organization_id	, presence: true  
	validate :end_time_after_start_time
	def end_time_after_start_time
		errors.add(:end_time, "can not be before the start time") if end_time < start_time
	end


	scope :by_organization, -> (org_id) {where(organization_id: org_id)}  

	# date_input is an object like the one returned from DateTime.now.to_date
	def self.is_within_unlocked_period(date_input, org_id)		
		return UnlockedTime.where("organization_id = ? AND ? >= start_time AND ? <= end_time", org_id,date_input, date_input).any?		
	end
	
end
