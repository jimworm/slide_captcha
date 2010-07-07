class SlideCaptchaController < ApplicationController
	def show
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

    begin
      @session = SlideCaptchaSession.find(params[:id])
      @file = "#{RAILS_ROOT}/tmp/cache/slide_captcha/#{@session.slide_captcha_code.code}.png"
    rescue ActiveRecord::RecordNotFound
      @session = nil
    end
    
    if @session and File.exist?(@file)
    	render :file => @file
    else
			render :text => '#{@file} does not exist, duplicate session or session might have expired'
		end
	end
end