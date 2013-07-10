class Workson < ActiveRecord::Base
	attr_accessible :user_id, :job_id
  
	belongs_to :user
	belongs_to :user_type
	
	validates :user_id, :job_id, :presence => true

end
