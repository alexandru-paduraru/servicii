class ApplicationController < ActionController::Base

  include PublicActivity::StoreController
  
  protect_from_forgery
  helper_method :current_user

  before_filter :require_login, :get_call_token



  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  hide_action :current_user
  
 private

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path # halts request cycle
    end
  end

  def logged_in?
    !!current_user
  end

  protected

  def get_call_token()
    #@default_number = "+14065521383"
    #@default_client = "close"

    account_sid = TWILIO_C['twilio']['account_sid']
    auth_token  = TWILIO_C['twilio']['auth_token']

    capability = Twilio::Util::Capability.new account_sid, auth_token

    capability.allow_client_outgoing TWILIO_C['twilio']['app_id']
    (capability.allow_client_incoming @current_organization.organization_phone_data.client_id) rescue ""

    @token = capability.generate
  end
end
