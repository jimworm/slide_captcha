require 'test_helper'

class SlideCaptchaCodeTest < ActiveSupport::TestCase
	def test_slide_captcha_code_exists
		assert_kind_of SlideCaptchaCode, SlideCaptchaCode.new
	end
	
	
end
