require 'test_helper'

class UserTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "user type attributes must not be empty" do type = UserType.new
  assert type.invalid?
  assert type.errors[:name].any?
  end
end
