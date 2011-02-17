require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @user = Factory.create(:admin_user)
  end
    
  def teardown
    @user.destroy
  end

  test "routing login -> new session" do
    assert_routing log_in_path, { :controller => "sessions", :action => "new" }
  end  

  test "viewing login form" do
    get :new
    assert_response :success
    assert_template :new
  end

  test "logging in with invalid password" do
    post :create, :email => @user.email, :password => @user.password.reverse
    assert_response :success
    assert_template :new
    assert_not_nil flash.alert
  end

  test "logging in with valid password" do
    post :create, :email => @user.email, :password => @user.password
    assert_redirected_to root_path
    assert_not_nil flash.notice
    assert_equal @user.to_param, session[:user_id]
  end

end
