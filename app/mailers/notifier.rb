class Notifier < ActionMailer::Base
  default from: "invoices@company.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.send_invoice.subject
  #
  def send_invoice(invoice)
    @message = invoice[:message]
    mail :to => invoice[:email], :subject => 'invoice' 
  end
  
  def send_email_invoice(invoice, services, customer)
	  		@invoice = invoice
	  		@services = services
	  		@customer = customer
	  		mail :to => @customer.email, :subject => "Invoice"
  end
  
  def send_email(to, cc, subject, message)
    @message = message
    mail :to => to, :subject => subject
  end
end
