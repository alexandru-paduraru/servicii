class Invoice < ActiveRecord::Base
  attr_accessible :date, :due_date, :amount, :number, :customer_id
  
  belongs_to :company
  belongs_to :customer
  
  has_many :transactions
  
  validates :date, :due_date, :amount, :number, :customer_id, :company_id, :presence => true

  
  def self.search(search)
  	if search
    	find(:all, :conditions => ['number LIKE ?', "%#{search}%"])
    else
    	find(:all)
    end
  end
  
  def self.import(file, current_user)
    errors_at_import = []
    index = 1
  	CSV.foreach(file.path, headers: true) do |row|
	  		invoice = Invoice.new
	  	    index += 1
	  	    invoice.date = row["date"]
	  	    invoice.due_date = row["due_date"]
	  	    invoice.amount = row["amount"]
	  	    invoice.number = row["number"]
	  	    invoice.customer_id = row["customer_id"]
	  		invoice.company_id = current_user[:company_id]
	  		if invoice.valid?
	  			invoice.save
	  		else
	  		    invoice.errors.full_messages.each do |error_message|
		  		    error = {}
		  		    error[:row] = index
		  		    error[:message] = error_message
		  			errors_at_import.append(error)
		  		end
	  		end
	 end
	 errors_at_import
	 
  end
  
  def self.to_csv(invoices)
    CSV.generate do |csv|
  		csv << column_names
  		invoices.each do |invoice|
  			csv << invoice.attributes.values_at(*column_names)
  		end
  	end
  end
end
