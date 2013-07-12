class UserType < ActiveRecord::Base
  attr_accessible :name
  
  has_many :worksons, :foreign_key => "job_id"
  
  validates :name, :presence => true
  
end
