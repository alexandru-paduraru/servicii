class Invoice < ActiveRecord::Base
  belongs_to :company
  belongs_to :customer
  
  has_many :transactions
  
    def self.search(search)
  	if search
    	find(:all, :conditions => ['number LIKE ?', "%#{search}%"])
    else
    	find(:all)
    end
  end
end
