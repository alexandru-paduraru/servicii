require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "user attributes must not be empty" do user = User.new
  assert user.invalid?
  assert user.errors[:first_name].any?
  assert user.errors[:last_name].any?
  assert user.errors[:email].any?
  assert user.errors[:job].any?
  end
  
  test "user email must be unique" do 
  	user = User.new(:email => users(:one).email,
:first_name => "first_name", :last_name => "last_name", :job => 1, :company_id => 1)

  assert !user.save
  assert_equal "has already been taken; is invalid", user.errors[:email].join('; ')
  end
  
end
