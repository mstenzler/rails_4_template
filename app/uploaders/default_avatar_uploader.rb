class DefaultAvatarUploader < CarrierWave::Uploader::Base
  
  include CarrierWave::MiniMagick

  MATCH_IMAGE_END = /.*\.(gif|jpg|jpeg|png)\Z/i
#  ORIGINAL_DEFAULT_AVATAR_SIZE = [400, 400]
  storage :file

  def store_dir
  	subdir = "default"
  	if !model.gender.nil?
  		subdir = model.gender.downcase
  	end
  	"images/default_avatar/#{subdir}"
  end

  process :resize_to_fit => CONFIG[:original_avatar_size] || [400, 400]

  version :large do
    process :resize_to_fit => CONFIG[:large_avatar_size] || [200, 200]
  end
  version :medium do
    process :resize_to_fit => CONFIG[:medium_avatar_size] || [100, 100]
  end
  version :small do
    process :resize_to_fit => CONFIG[:small_avatar_size] || [60, 60]
  end
  version :tiny do
    process :resize_to_fit => CONFIG[:tiny_avatar_size] || [30, 30]
  end

  def extension_white_list
  	%w(jpg jpeg gif png)
  end

  def filename
    match  = MATCH_IMAGE_END.match(@filename)
    image_end = (match.nil? || match.size < 2 || match[1].blank?) ? "" : ".#{match[1]}"
    "avatar#{image_end}"
  end
end
