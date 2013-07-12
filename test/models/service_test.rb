require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "service attributes must not be empty" do service = Service.new
  assert service.invalid?
  assert service.errors[:name].any?
  assert service.errors[:value].any?
  end
  
  
end
