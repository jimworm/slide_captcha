require 'test_help'
require 'test_helper'
include SlideCaptchaHelper

class SlideCaptchaHelperTest < ActiveSupport::TestCase
	def test_tags
		assert_equal 'success', slide_captcha_tags
	end
end