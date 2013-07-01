class Customer < ActiveRecord::Base
  belongs_to :company
  has_many :invoices
  has_many :transactions
  
  def self.search(search)
  	if search
    	find(:all, :conditions => ['first_name or last_name LIKE ?', "%#{search}%"])
    else
    	find(:all)
    end
  end
end
