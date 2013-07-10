class Invoice < ActiveRecord::Base
  attr_accessible :date, :due_date, :amount, :number, :customer_id, :company_id, :user_id
  
  belongs_to :company
  belongs_to :customer
  
  has_many :transactions
  has_many :email_actions
  		   validates :date, :due_date, :amount, :number, :customer_id, :company_id, :presence => true
   validates :amount, :numericality => {:greater_than_or_equal_to => 0.01}
#    validates :date, :format =>{ :with => /(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d/ }

 
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
  
  def self.generate_number
  	number = 00001
     if Invoice.all != []
         invoice = Invoice.all.order('number asc').last
         number = invoice[:number] + 1
     end
     number
  end
  
   def self.index(company_id)
     all.where(:company_id => company_id).order('date asc')
   end
end
