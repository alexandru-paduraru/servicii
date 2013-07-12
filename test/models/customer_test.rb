
require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "coustomer attributes must not be empty" do customer = Customer.new
  assert customer.invalid?
  assert customer.errors[:first_name].any?
  assert customer.errors[:last_name].any?
  assert customer.errors[:email].any?
  assert customer.errors[:phone].any?
  assert customer.errors[:address1].any?
  assert customer.errors[:zip_code].any?
  end
  
    test "customer account must be unique" do 
  	customer = Customer.new(:account => customers(:one).account,
:first_name => "first_name", :last_name => "last_name", :user_id => 1, :company_id => 1, :email => "email@email.com", :phone => "11111", :address1 => "address1", :zip_code => "11111", :state => "state", :city => "city", :account => "11111")

  assert !customer.save
#   assert_equal "has already been taken", customer.errors[:account].join('; ')
  end
  
    test "customer email must be unique" do 
  	customer = Customer.new(:email => customers(:one).email,
:first_name => "first_name", :last_name => "last_name", :user_id => 1, :company_id => 1, :email => "email@email.com", :phone => "11111", :address1 => "address1", :zip_code => "11111", :state => "state", :city => "city", :account => "11111")

  assert !customer.save
#   assert_equal "has already been taken; is invalid", customer.errors[:email].join('; ')
  end

end
