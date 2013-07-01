class Company < ActiveRecord::Base
  attr_accessible :address, :city, :country, :county, :name, :zip_code
  
  has_many :users, :foreign_key => "company_id"
  has_many :customers
  has_many :invoices
  has_many :transactions
  
  validates :name, :address, :city, :country, :zip_code, :presence => true
  validates :name, :length => { :minimum => 2 }
  validates_uniqueness_of :name
   
end
