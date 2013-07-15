require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "send_invoice" do
    invoice = {}
    invoice[:email]="user@user.com"
    invoice[:message]="hello"
    mail = Notifier.send_invoice(invoice)
    assert_equal "invoice", mail.subject
    assert_equal [invoice[:email]], mail.to
    assert_equal ["invoice@example.com"], mail.from
    assert_match invoice[:message], mail.body.encoded
  end

end
