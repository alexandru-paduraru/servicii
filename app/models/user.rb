require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :first_name, :last_name, :password_hash, :password_salt, :type
  include BCrypt
  
#  belongs_to :user_type
  belongs_to :company
  has_many :worksons, :foreign_key => "user_id"
  
  validates_uniqueness_of :email

  def password
      @password ||= Password.new(password_hash)
  end

  def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
  end
    
  def self.authenticate(email_param, password_param)
   if @user = find_by_email(email_param)
   		p '****************************** user gasit ************************************'
	   if @user.password == password_param
	   	p '****************************** parola buna ************************************'
	   		@user
	   	else
	   	p '****************************** PAROLA GREGISTA ************************************'
	   	    nil
	   end
	else
		p '****************************** nu exista user ************************************'
	   nil
   end
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
