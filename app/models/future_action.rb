class FutureAction < ActiveRecord::Base

  attr_accessible :invoice_id, :sms_notification, :email_notification, :duration_type, :starting_day, :starting_week_day, :invoice_creation

  DAILY   = 1
  WEEKLY  = 2
  MONTHLY = 3

  has_many :invoices
end
