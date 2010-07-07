require 'test_helper'

class SlideCaptchaSessionTest < ActiveSupport::TestCase
	def test_slide_captcha_session_exists
		assert_kind_of SlideCaptchaSession, SlideCaptchaSession.new
	end
end
