require 'test_helper'

class SlideCaptchaControllerTest < ActionController::TestCase
  def setup
    @controller = SlideCaptchaController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    ActionController::Routing::Routes.draw do |map|
      map.slide_captcha 'slide_captcha/:id', :controller => 'slide_captcha', :action => :show
    end
  end

  test "show" do
  	get :show
    assert_response :success
  end
end
