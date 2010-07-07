require 'test_helper'
include SlideCaptchaHelper

class SlideCaptchaHelperTest < Test::Unit::TestCase
	def test_tags
		assert_equal 'success', slide_captcha_tags
	end
end