require 'test_helper'

class FutureActionsControllerTest < ActionController::TestCase
  setup do
    @future_action = future_actions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:future_actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create future_action" do
    assert_difference('FutureAction.count') do
      post :create, future_action: { duration_type: @future_action.duration_type, email_notification: @future_action.email_notification, invoice_id: @future_action.invoice_id, sms_notification: @future_action.sms_notification, starting_day: @future_action.starting_day, starting_week_day: @future_action.starting_week_day }
    end

    assert_redirected_to future_action_path(assigns(:future_action))
  end

  test "should show future_action" do
    get :show, id: @future_action
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @future_action
    assert_response :success
  end

  test "should update future_action" do
    patch :update, id: @future_action, future_action: { duration_type: @future_action.duration_type, email_notification: @future_action.email_notification, invoice_id: @future_action.invoice_id, sms_notification: @future_action.sms_notification, starting_day: @future_action.starting_day, starting_week_day: @future_action.starting_week_day }
    assert_redirected_to future_action_path(assigns(:future_action))
  end

  test "should destroy future_action" do
    assert_difference('FutureAction.count', -1) do
      delete :destroy, id: @future_action
    end

    assert_redirected_to future_actions_path
  end
end
