class Notifier < ActionMailer::Base
  default from: "invoice@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.send_invoice.subject
  #
  def send_invoice(invoice)
    @message = invoice[:message]
    mail :to => invoice[:email], :subject => 'invoice' 
  end
end
