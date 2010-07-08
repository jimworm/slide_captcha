require 'active_record'
require File.dirname(__FILE__) + '/../app/models/slide_captcha_code'
require File.dirname(__FILE__) + '/../app/models/slide_captcha_session'
require File.dirname(__FILE__) + '/../db/migrate/add_slide_captcha_tables'

namespace :db do
  namespace :migrate do
		namespace :slide_captcha do  
	    task :up => :environment do
	    	AddSlideCaptchaTables::up
	    end
	    task :down => :environment do
	    	require 'vendor/plugins/slide_captcha/db/migrate/add_slide_captcha_tables'
	    	AddSlideCaptchaTables::down
	    end
	  end
  end
end

namespace :slide_captcha do 
	require 'rubygems'
	require 'GD'
	require 'ftools'
	require 'RMagick'
	require 'graphics.rb'
	include Magick
 	config = YAML::load(IO.read('config/database.yml'))
	ActiveRecord::Base.establish_connection(config[RAILS_ENV])
	
	task :build_codes do
		if ENV.include?('length') && ENV['length'].to_i > 0
			length = ENV['length'].to_i
		else
			length = 7
		end
		
		if ENV.include?('n') && ENV['n'].to_i > 0
			n = ENV['n'].to_i
		else
			n = 10000
		end
		
		if 26**length < n*10
			puts "Warning: code length is too short for number of codes requested, task may not finish due to duplicates."
			puts "Code build aborted"
		else
			n.times do
				begin
					code = Array.new(length) { (rand(122-97) + 97).chr }.join
				end until !SlideCaptchaCode.exists?(:code => code)
				SlideCaptchaCode.create :code => code
				puts code
			end
			puts "#{n} codes generated"
		end
	end
	
	task :generate_images do
		count = SlideCaptchaCode.count
		if count > 0
			puts "#{count} images to generate"
			SlideCaptchaCode.all.each do |code|
				code.generate_image
			end
			puts "Image generation complete"
		else
			puts 'No codes in database. Run "rake slide_captcha:build_codes" to generate codes first'
		end
	end
	
	task :expire_sessions do
		ENV['before'] ||= '30.minutes.ago'
		time_limit = eval ENV['before']
		n = SlideCaptchaSession.delete_all(["created_at < ?", time_limit])
		puts "Deleted #{n} sessions dated before #{time_limit}"
	end
end