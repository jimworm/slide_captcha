# SlideCaptcha

#config.draw_for :slide_captcha do |map|
#	map.slide_captcha 'slide_captcha/:id', :controller => 'slide_captcha', :action => :show
#end

require 'slide_captcha/verify'

ActionView::Base.send(:include, SlideCaptchaHelper)
ActionController::Base.send(:include, SlideCaptcha::Verify)
ActionView::Helpers::AssetTagHelper.register_javascript_include_default 'slider'