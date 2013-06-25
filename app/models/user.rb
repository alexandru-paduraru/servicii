class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :first_name, :last_name, :password_hash, :password_salt, :type
  
  belongs_to :user_type
  belongs_to :company

end
