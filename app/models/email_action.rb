class EmailAction < ActiveRecord::Base
  attr_accessible :sent_at, :viewed_at, :mandrill_id, :user_id
  
  belongs_to :customer
  belongs_to :invoice
  
  require 'mandrill' 
   
	 def self.send_email(_post,invoice_id,current_user)
	 	m = Mandrill::API.new
	 	pay_link = "<a href='http://localhost:3000/invoice_pay/#{invoice_id}'>Pay</a>"
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
		 :headers => {"X-MC-Track"=>"opens"},
		 :track_opens => true,
		 :track_clicks => true,
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
		 :from_email=>"admin@mandrill.com"
		}
		sending = m.messages.send_template template_name, template_content, message
        
##### saving the email details in the database ########		
		email = EmailAction.new
		email.sent_at = Time.now.to_datetime
		email.customer_id = _post[:customer_id]
		email.invoice_id = invoice_id
		email.mandrill_id = sending[0]["_id"]          # POSIBIL PROBLEMA, dureaza pana primesti id de la mandril
		email.user_id = current_user.id
		email.save
	
	 end
	 
	 def self.refresh_info(email) #face refresh la informatia despre email doar daca au trecut 30 minute de la trimitere
	 difference = Time.zone.now - email.sent_at
	 if difference > 1000
	 	m = Mandrill::API.new
        id = email.mandrill_id
        if id
        	if (m.messages.info id)
        		result = m.messages.info id
		        if result["opens"] > 0
		            datetime = Time.at(result["opens_detail"][0]["ts"]).to_datetime
		            email.update_attribute(:viewed_at, datetime)
		        end	
	        end
        end 
      end
     
	 end

	 
	 def self.user_info
	 	m = Mandrill::API.new
	 	result = m.users.info
	 	result
	 end
	 
	 def self.last_action(customer)
		if customer
	  		customer.email_actions.order('sent_at asc').last
	  	else
	  		nil
	  	end
	 end

  
end
