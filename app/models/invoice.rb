class Invoice < ActiveRecord::Base
  attr_accessible :date, :due_date, :amount, :number, :customer_id, :company_id, :user_id
  
  belongs_to :company
  belongs_to :customer
  
  has_many :transactions
  has_many :email_actions
  
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
  
  def self.generate_number
  	number = 00001
     if Invoice.all != []
         invoice = Invoice.all.order('number asc').last
         number = invoice[:number] + 1
     end
     number
  end
  
  def self.save_invoice(post, current_user)
  	invoice = Invoice.new(:date => Time.now, :customer_id => post[:customer_id], :user_id => current_user.id, :company_id => current_user.company_id, :due_date => post[:due_date], :amount => post[:amount])
  	invoice.number = Invoice.generate_number
  	
  	if invoice.save
  		id_inv = invoice.id
  		# pentru servicii multiple va fi un for
  		if s1 = post[:service_1]
        	id_serv = Service.add_service(s1[:service_name], s1[:service_value], invoice[:company_id])
        	
        	rel = InvoiceHasService.new
        	rel[:invoice_id] = id_inv
        	rel[:service_id] = id_serv
        	if s1[:service_qty]
        		rel[:qty] = s1[:service_qty]
        	end
        	rel.save
 
        end
        id_inv
      else
      	nil
  	end
  	
  end
end
