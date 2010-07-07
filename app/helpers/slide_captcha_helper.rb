module SlideCaptchaHelper
	def slide_captcha_tags
		session = SlideCaptchaCode.random.create_session
		render :partial => 'slide_captcha/tags', :locals => {:id => session.id}
	end
	
	def slide_captcha_styles
		stylesheet_link_tag('slide_captcha')
	end
end