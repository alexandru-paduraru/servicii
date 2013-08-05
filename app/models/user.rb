require 'bcrypt'

class User < ActiveRecord::Base
    ADMIN = 1
    EMPLOYEE = 0
  include BCrypt
  include PublicActivity::Model
  tracked owner: ->(controller,model) {controller && controller.current_user}
  attr_accessible :company_id, :email, :first_name, :last_name, :password_hash, :password_salt, :type, :job


  #  belongs_to :user_type
  belongs_to :company
  has_many :worksons
  
  validates :first_name, :last_name, :email, :job, :presence => true
  validates :email, :length => { :minimum => 5 } 
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def password
      @password ||= Password.new(password_hash)
  end

  def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
  end

  def self.authenticate(email_param, password_param)
   if @user = find_by_email(email_param)
	   if @user.password == password_param
	   		@user
	   	else
	   	  nil
	   end
	else
	   nil
   end
  end

  def self.index_by_company(company_id)
  	all.where(:company_id => company_id)
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
