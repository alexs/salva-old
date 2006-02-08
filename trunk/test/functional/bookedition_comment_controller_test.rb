require File.dirname(__FILE__) + '/../test_helper'
require 'bookedition_comment_controller'

# Re-raise errors caught by the controller.
class BookeditionCommentController; def rescue_action(e) raise e end; end

class BookeditionCommentControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  include AuthenticatedTestHelper

  fixtures :bookedition_comments

  def setup
    @controller = BookeditionCommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :login, :login => 'quentin', :password => 'quentin'
    assert session[:bookedition_comment]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :login, :login => 'quentin', :password => 'bad password'
    assert_nil session[:bookedition_comment]
    assert_response :success
  end

  def test_should_allow_signup
    old_count = BookeditionComment.count
    create_bookedition_comment
    assert_response :redirect
    assert_equal old_count+1, BookeditionComment.count
  end

  def test_should_require_login_on_signup
    old_count = BookeditionComment.count
    create_bookedition_comment(:login => nil)
    assert assigns(:bookedition_comment).errors.on(:login)
    assert_response :success
    assert_equal old_count, BookeditionComment.count
  end

  def test_should_require_password_on_signup
    old_count = BookeditionComment.count
    create_bookedition_comment(:password => nil)
    assert assigns(:bookedition_comment).errors.on(:password)
    assert_response :success
    assert_equal old_count, BookeditionComment.count
  end

  def test_should_require_password_confirmation_on_signup
    old_count = BookeditionComment.count
    create_bookedition_comment(:password_confirmation => nil)
    assert assigns(:bookedition_comment).errors.on(:password_confirmation)
    assert_response :success
    assert_equal old_count, BookeditionComment.count
  end

  def test_should_require_email_on_signup
    old_count = BookeditionComment.count
    create_bookedition_comment(:email => nil)
    assert assigns(:bookedition_comment).errors.on(:email)
    assert_response :success
    assert_equal old_count, BookeditionComment.count
  end

  def test_should_logout
    login_as :quentin
    get :logout
    assert_nil session[:bookedition_comment]
    assert_response :redirect
  end
  
  protected
  def create_bookedition_comment(options = {})
    post :signup, :bookedition_comment => { :login => 'quire', :email => 'quire@example.com', 
                             :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end
