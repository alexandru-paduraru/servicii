require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "invoice attributes must not be empty" do invoice = Invoice.new
  assert invoice.invalid?
  assert invoice.errors[:date].any?
  assert invoice.errors[:due_date].any?
  assert invoice.errors[:amount].any?
  assert invoice.errors[:number].any?
  end
end
