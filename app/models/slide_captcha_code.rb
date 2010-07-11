class SlideCaptchaCode < ActiveRecord::Base
	has_many :slide_captcha_sessions
	
	IMAGE_WIDTH = 250
	IMAGE_HEIGHT = 50
	N_SLICES = 10
	
	def self.random
    find(:first, :order => "rand()")
  end
	
	def create_session
		SlideCaptchaSession.create :slide_captcha_code => self
	end
	
	def generate_image
		image_path = "#{RAILS_ROOT}/tmp/cache/slide_captcha/#{code}.png"
		font_path = "#{RAILS_ROOT}/vendor/plugins/slide_captcha/lib/fonts/"
		width = IMAGE_WIDTH
		height = IMAGE_HEIGHT
		n_slices = N_SLICES
		
		font_exts = %w(ttf ffil dfont)
		fonts = []
		Dir.foreach(font_path) do |f|
			ext = f.partition('.').last
			fonts.push(f.to_s) if font_exts.include?(ext)
		end
		
		source_image = GD::Image.newTrueColor(width, height)
		bg_color = source_image.colorAllocate(255, 255, 255)
		font_color = source_image.colorAllocate(78, 78, 78)
		font_size = 30
		font_file = "#{font_path}#{fonts.shuffle[0]}"
		
		source_image.filledRectangle(0, 0, width, height, bg_color)
		source_image.stringFT(font_color, font_file, font_size, 0, 10, 40, random_case_code)
		output_image = GD::Image.newTrueColor(width, height)
		
		offset = rand(113) + 12
		slice_height = height / n_slices
		
		for slice in 1..n_slices do
			if slice % 2 == 0
				slice_offset = offset
			else
				slice_offset = width - offset
			end
			a_width = slice_offset
			b_width = width - slice_offset
			y = (slice - 1) * slice_height
			
			source_image.copy(output_image, 0, y, slice_offset, y, b_width, slice_height)
			source_image.copy(output_image, b_width, y, 0, y, a_width, slice_height)
		end
		
		(1..(height - 1)).step(2) do |n|
			output_image.filledRectangle(0, n, width, n+1, rand(2) == 0 ? font_color : bg_color) if n % 2 == 1 and rand(4) == 0
		end
		(1..(width - 1)).step(2) do |n|
			output_image.line(n + (rand(9) - 2), 0, n + (rand(9) - 2), height, rand(2) == 0 ? font_color : bg_color) if n % 2 == 1 and rand(6) == 0
		end
		
		# make the directory if it doesn't already exist
    FileUtils.makedirs File.dirname(image_path)
		output_image.send('png', File.open(image_path, 'w'))
	end
	
	def random_case_code
		output = ''
		code.each_char do |c|
			if c == 'l'
				output += c.upcase
			elsif c == 'i'
				output += c
			else
				output += (rand(2).odd?) ? c : c.upcase
			end
		end
		output
	end
end
