class Workson < ActiveRecord::Base

    include PublicActivity::Model
    tracked except: [:create,:destroy], owner: ->(controller,model) {controller && controller.current_user}
  
    has_paper_trail
    
    ACCOUNTS = 2
    FINANCIALS = 3
    COLLECTIONS = 4
	attr_accessible :user_id, :job_id
  
	belongs_to :user
	belongs_to :user_type
	
	validates :user_id, :job_id, :presence => true

end
