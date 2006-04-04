require File.dirname(__FILE__) + '/../test_helper'
require 'jobpositiontype_controller'

# Re-raise errors caught by the controller.
class JobpositiontypeController; def rescue_action(e) raise e end; end

class JobpositiontypeControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  include AuthenticatedTestHelper

  fixtures :jobpositiontypes

  def setup
    @controller = JobpositiontypeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :login, :login => 'quentin', :password => 'quentin'
    assert session[:jobpositiontype]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :login, :login => 'quentin', :password => 'bad password'
    assert_nil session[:jobpositiontype]
    assert_response :success
  end

  def test_should_allow_signup
    old_count = Jobpositiontype.count
    create_jobpositiontype
    assert_response :redirect
    assert_equal old_count+1, Jobpositiontype.count
  end

  def test_should_require_login_on_signup
    old_count = Jobpositiontype.count
    create_jobpositiontype(:login => nil)
    assert assigns(:jobpositiontype).errors.on(:login)
    assert_response :success
    assert_equal old_count, Jobpositiontype.count
  end

  def test_should_require_password_on_signup
    old_count = Jobpositiontype.count
    create_jobpositiontype(:password => nil)
    assert assigns(:jobpositiontype).errors.on(:password)
    assert_response :success
    assert_equal old_count, Jobpositiontype.count
  end

  def test_should_require_password_confirmation_on_signup
    old_count = Jobpositiontype.count
    create_jobpositiontype(:password_confirmation => nil)
    assert assigns(:jobpositiontype).errors.on(:password_confirmation)
    assert_response :success
    assert_equal old_count, Jobpositiontype.count
  end

  def test_should_require_email_on_signup
    old_count = Jobpositiontype.count
    create_jobpositiontype(:email => nil)
    assert assigns(:jobpositiontype).errors.on(:email)
    assert_response :success
    assert_equal old_count, Jobpositiontype.count
  end

  def test_should_logout
    login_as :quentin
    get :logout
    assert_nil session[:jobpositiontype]
    assert_response :redirect
  end
  
  protected
  def create_jobpositiontype(options = {})
    post :signup, :jobpositiontype => { :login => 'quire', :email => 'quire@example.com', 
                             :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end