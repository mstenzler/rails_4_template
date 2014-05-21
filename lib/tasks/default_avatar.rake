require 'carrierwave/orm/activerecord'
#require File.expand_path('../../../app/models/user.rb', __FILE__)

namespace :avatar do
	desc "Loads a default avatar file"
	task :load_default, [:image, :gender] => :environment do |t, args|
		p "args = #{args}"

		image_path = args[:image]
		gender = args[:gender] || nil

		unless image_path
			puts "ERROR! no image given!"
			next
		end

		image = File.open(image_path)

		unless image
			puts "Error! Could not open image: #{image_path}"
			next
		end

		puts "loading image #{image_path}"

		model = DefaultAvatar.new
		model.gender = gender unless gender.nil?
		model.avatar = image
		model.save

		puts "Done."
		puts "image url = #{model.avatar.url}"
		puts "image current_path = #{model.avatar.current_path}"
		puts "identifier = #{model.avatar.identifier}"

	end
end