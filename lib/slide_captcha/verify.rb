module SlideCaptcha
  module Verify
    def verify_slide_captcha(options = {})
      if !options.is_a? Hash
        options = {:model => options}
      end
      model = options[:model]
      
      response = params[:slide_captcha_response].is_a?(Hash) ? params[:slide_captcha_response] : {}
      
      unless SlideCaptchaSession::match?(response)
        if model
          model.valid?
          model.errors.add :base, options[:message] || "Word verification response is incorrect, please try again."
        end
        return false
      else
        return true
      end
    end
  end
end