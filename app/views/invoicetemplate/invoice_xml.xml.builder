xml = Builder::XmlMarkup.new

xml.instruct! :xml, :version => "1.0"

xml.invoice do

 xml.number @invoice.number
 xml.date @invoice.date
 xml.due_date @invoice.due_date
 
 xml.customer do 
    xml.first_name @customer.first_name
    xml.last_name @customer.last_name
    xml.organization_name @customer.organization_name
    xml.email @customer.email
    xml.phone @customer.phone
    xml.description @customer.description
    xml.state @customer.state
    xml.city @customer.city
    xml.zipcode @customer.zip_code
    xml.address1 @customer.address1
    xml.address2 @customer.address2
 end 
 
 xml.company do
    xml.company_name @company.name
    xml.address @company.address
    xml.country @company.country
    xml.county @company.county
    xml.city @company.city
    xml.zipcode @company.zip_code
 end

 xml.services do 
     @services.each do |service|
        xml.service do
            xml.name service[:name]
            xml.price service[:value]
            xml.qty service[:qty]
        end
     end 
 end
end
