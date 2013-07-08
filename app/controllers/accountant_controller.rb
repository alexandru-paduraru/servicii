require 'mandrill' 

class AccountantController < ApplicationController

 def index
 	@invoices = Invoice.search(params[:search])
 	render 'index'
 end
 
 def invoice_details
  	 @invoice_id = params[:invoice_id]
	 @invoice = Invoice.find(@invoice_id)
	 
	 @customer_id = @invoice.customer_id
	 @customer = Customer.find(@customer_id)
	 
	 respond_to do |format|
	 	format.html {render 'invoice_details'}
	 end
 end
 
	 def invoice_new
		 @invoice = Invoice.new
		 respond_to do |format|
	     	 	format.html  {render 'invoice_new'}
	     	 	format.json { render json: @invoice }
	     end
	 end
<<<<<<< HEAD
 
	 def send_email(_post,invoice)
	 	m = Mandrill::API.new
	 	pay_link = "<a href='http://localhost:3000/invoice_pay/#{invoice.id}'>Pay</a>"
	 	template_name = "invoice_template"
	 	template_content = [{"name" => "customer_id", "content" => _post[:customer_id]},{"name" => "due_date", "content" => _post[:due_date]},{"name" => "amount", "content" => _post[:amount]},{"name" => "service_name", "content" => _post[:service_1][:service_name]},{"name" => "service_value", "content" => _post[:service_1][:service_value]},{"name" => "service_qty", "content" => _post[:service_1][:service_qty]},{"name" => "pay", "content" => pay_link }]
		message = {
		 :subject=> "Invoice details",
		 :from_name=> "Companie de trimis facturi",
		 :text=>"Details",
		 :to=>[
		   {
		     :email=> _post[:customer_email],
		     :name=> _post[:customer_name]
		   }
		 ],
		 :html=>"Total amount #{_post[:amount]}",
		 # :html=>"<html><table>             DE FACUT SA MEARGA HTML 
# 		 	<tr>
# 		 		<th>Customer id</th>
# 		 		<th>Due Date</th>
# 		 		<th>Amount</th>
# 		 	</tr>
# 		 	<tr>
# 		 		<td>#{_post[:customer_id]}</td>
# 		 		<td>#{_post[:due_date]}</td>
# 		 		<td>#{_post[:amount]}</td>
# 		 	</tr>
# 		 </table>
# 		 <h4>Services</h4>
# 		 <table>
# 		 	<tr>
# 		 		<th>Service name</th>
# 		 		<th>Value</th>
# 		 		<th>Qty</th>
# 		 	</tr>
# 		 	<tr>
# 		 		<td>#{_post['service_1']['service_name']}</td>
# 		 		<td>#{_post['service_1']['service_value']}</td>
# 		 		<td>#{_post['service_1']['service_qty']}</td>
# 		 	</tr>
# 		 	<tr>
# 		 		<td>#{_post['service_2']['service_name']}</td>
# 		 		<td>#{_post['service_2']['service_value']}</td>
# 		 		<td>#{_post['service_2']['service_qty']}</td>
# 		 	</tr>
# 
# 		 </table>
# 		 <a href='http://google.ro'>Pay</button>
# 		 </html>",
		 :from_email=>"gherghe_neculai@yahoo.com"
		}
		sending = m.messages.send_template template_name, template_content, message
		puts sending
		redirect_to customer_details_path(:customer_id => _post[:customer_id]), :notice => "Success! Invoice created. An email with details was sent to customer."
=======

#### view for opening a new invoice from a customer details

    def customer_new_invoice
    	customer_id = params[:customer_id]
		@customer = Customer.find(customer_id)
		@invoice = Invoice.new
<<<<<<< HEAD
# 		respond_to do |format|
# 			format.html {render 'customer_new_invoice'}
# 		end
        render 'customer_new_invoice'
>>>>>>> cbcee06e1bc20aeeafd5f3a6b6a9fccdb4b08a1f
=======
		respond_to do |format|
			format.html {render 'customer_new_invoice'}
		end

>>>>>>> 59ce4924c839963d4486da245974af4eb8425c8e
		
    end
 
   def invoice_create
        if params[:send] || params[:draft]
        _post = params[:invoice]
  		invoice = Invoice.new
        invoice[:amount] = _post[:amount]
        invoice[:due_date] = _post[:due_date]
        invoice[:customer_id] = _post[:customer_id]
        invoice[:date] = Time.now
        invoice[:number] = Invoice.generate_number #algorithm for generating the invoice number?

        
        if current_user.company_id
        	invoice[:company_id] = current_user.company_id
        else
        	invoice[:company_id] = 0 
        end
        
 ###saving the services in the database     
        if s1 = _post[:service_1]
        	Service.add_service(s1[:service_name], s1[:service_value], invoice[:company_id])
        end
        
        if invoice.save
           if params[:send]
           redirect_to customer_details_path(:customer_id => invoice[:customer_id]), :notice => "Success! Invoice created. An email with details was sent to customer."
           EmailAction.send_email(_post,invoice) 
           end
           if params[:draft]
           redirect_to customer_details_path(:customer_id => invoice[:customer_id]), :notice => "Success! Invoice saved as draft."
           end
        else
           redirect_to customer_details_path(:customer_id => invoice[:customer_id]), :alert => "Error creating invoice ! "
        end
     end

 
   end
   
   def invoices_import_export
   
	   respond_to do |format|
	   	format.html {render 'invoices_import_export'}
	   end
   
   end
   
   def invoice_import
   	     @errors = []
	    
	    if(params[:file])
	 		@errors = Invoice.import(params[:file], current_user)
	    end
	    
	    
	    if @errors != []
	        string = ""
	        @errors.each do |error|
	        string += "Row " + error[:row].to_s+ ": " + error [:message] + "\n"
	        end
	 		redirect_to invoices_import_export_path, :notice => string
	 	else
	 	 	redirect_to invoices_import_export_path, :notice => "Invoices imported."
	 	end

   end
   
   def invoice_export
    @invoices = Invoice.all
	   	respond_to do |format|
		   	format.html {render 'invoices_import_export'}
		   	format.csv {send_data Invoice.to_csv(@invoices)}
	   	end
   end
 
   def invoice_pay
   	   @invoice = Invoice.find(params[:invoice_id])
   end
   
end
