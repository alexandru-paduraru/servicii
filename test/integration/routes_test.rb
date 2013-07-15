
require 'test_helper'

class RoutesTest < ActionController::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "should logout" do
  assert_routing '/logout', {controller: "session", action: "destroy_user"}
  end
  
  test "should route to signup" do
  assert_routing '/signup', {controller: "session", action: "signup"}
  end

  test "should route to login" do
  assert_routing '/login', {controller: "session", action: "login"}
  end
  
  test "should route to salesman index" do
  assert_routing '/salesman', {controller: "salesman", action: "index"}
  end
  
  test "should route to accountant index" do
  assert_routing '/accountant', {controller: "accountant", action: "index"}
  end
  
  test "should route to collector index" do
  assert_routing '/collector', {controller: "collector", action: "index"}
  end
  
  test "should route to admin index" do
  assert_routing '/admin', {controller: "admin", action: "index"}
  end
  
  test "should route to user index" do
  assert_routing '/users', {controller: "user", action: "index"}
  end
  
  test "should route to salesman_new" do
  assert_routing '/salesman_new', {controller: "salesman", action: "new"}
  end
  	
end
