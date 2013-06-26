class UserType < ActiveRecord::Base
  attr_accessible :name
  
  has_many :users, :foreign_key => "job"
  
end
