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
  
  def self.import(file)
  	CSV.foreach(file.path, headers: true) do |row|
  		a = Customer.new(row.to_hash)
  		a.company_id = current_user[:company_id]
  		a.save
  	end
  end
end
