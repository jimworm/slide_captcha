class SlideCaptchaCode < ActiveRecord::Base
	has_many :slide_captcha_sessions
	
	def self.random
    find(:first, :order => "rand()")
  end
	
	def create_session
		SlideCaptchaSession.create :slide_captcha_code => self
	end
	
	def generate_image
		image_path = "#{RAILS_ROOT}/tmp/cache/slide_captcha/#{code}.png"
		width = 250
		height = 50
		
		top_height = height / 2
		bottom_height = height - top_height
		offset = wrapped_width = rand(113) + 12
		unwrapped_width = width - offset
		
		source_image = GD::Image.newTrueColor(width, height)
		bg_color = source_image.colorAllocate(255, 255, 255)
		font_color = source_image.colorAllocate(178, 178, 178)
		font_size = 30
		font_file = 'vendor/plugins/slide_captcha/lib/arialmtrbd.ttf'
		
		source_image.filledRectangle(0, 0, width, height, bg_color)
		source_image.stringFT(font_color, font_file, font_size, 0, 30, 40, random_case_code)
		output_image = GD::Image.newTrueColor(width, height)
		source_image.copy(output_image, 0, 0, offset, 0, unwrapped_width, top_height)
		source_image.copy(output_image, unwrapped_width, 0, 0, 0, wrapped_width, top_height)
		source_image.copy(output_image, 0, top_height, unwrapped_width, top_height, wrapped_width, bottom_height)
		source_image.copy(output_image, offset, top_height, 0, top_height, unwrapped_width, bottom_height)
		
		# make the directory if it doesn't already exist
    File.makedirs File.dirname(image_path)
		output_image.send('png', File.open(image_path, 'w'))
	end
	
	def random_case_code
		output = ''
		code.each_char do |c|
			output += (rand(2).odd?) ? c : c.upcase
		end
		output
	end
end
