require 'test_helper'

class SlideCaptchaTest < ActiveSupport::TestCase
  load_schema
	
  def test_schema_has_loaded_correctly
    assert_equal [], SlideCaptchaCode.all
    assert_equal [], SlideCaptchaSession.all
  end

end

