class RecurringInvoice < ActiveRecord::Base
  attr_accessible :sms_notification, :email_notification, :daily, :weekly, :monthly, :invoice_id, :sms_phone, :sms_body
  belongs_to :invoice
  #has_one recurring

  def check_or_send(r_i)
    if self.daily == true

    elsif self.weekly == true && DateTime.now.wday == 1
    end
  end

  def send_notifications
    if sms_notification == true
      # TODO: send SMS
    elsif email_notification == true
    end
  end
end
