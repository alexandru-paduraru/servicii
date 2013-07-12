
require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "company attributes must not be empty" do company = Company.new
  assert company.invalid?
  assert company.errors[:name].any?, "name must be present"
  assert company.errors[:address].any?, "address must be present"
  assert company.errors[:country].any?, "country must be present"
  assert company.errors[:zip_code].any?,"zipcode must be present"
  end

end
