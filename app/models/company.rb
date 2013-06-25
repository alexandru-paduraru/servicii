class Company < ActiveRecord::Base
  attr_accessible :address, :city, :country, :county, :name, :zip_code
  
 has_many :users, :foreign_key => "company_id"
  
end
