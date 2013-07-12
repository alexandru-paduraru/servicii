require 'test_helper'

class EmailActionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "action attributes must not be empty" do action = EmailAction.new
  assert action.invalid?
  assert action.errors[:sent_at].any?
  end
end
