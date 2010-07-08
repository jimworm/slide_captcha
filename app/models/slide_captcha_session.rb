class SlideCaptchaSession < ActiveRecord::Base
	belongs_to :slide_captcha_code
	
	def self.match?(response)
		begin
			session = self.find(response[:id])
			match = (response[:code].downcase == session.slide_captcha_code.code &&
								session.created_at > 30.minutes.ago)
			session.destroy
		rescue ActiveRecord::RecordNotFound
			match = false
		end
		
		match
	end
end