class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :first_name, :last_name, :password_hash, :password_salt, :type
  
#  belongs_to :user_type
  belongs_to :company
  has_many :worksons, :foreign_key => "user_id"
  
  validates_uniqueness_of :email

  def self.authenticate(email, password)
   user = find_by_email(email)
 	if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
 		user
 	else
 		nil
    end
  end

  def self.encrypt_password(password)
    pass = {}
      if password
      pass[:password_salt] = BCrypt::Engine.generate_salt
      pass[:password_hash] = BCrypt::Engine.hash_secret(password, pass[:password_salt])
      end
    pass
  end

  def self.details(id)
    details = {}
  	user = User.find(id)
  	works_on = Workson.all(:conditions => { :user_id => id })
  	details[:id] = user.id
  	details[:first_name] = user.first_name
  	details[:last_name] = user.last_name
  	details[:email] = user.email
  	details[:job] = works_on
  	details
  end
  
end
