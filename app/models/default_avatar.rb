class DefaultAvatar
  include ActiveModel::Model
  extend CarrierWave::Mount
#  require 'carrierwave/orm/activerecord'

 attr_accessor :avatar, :gender

 IMAGE_RESIZE_MAP = User::IMAGE_RESIZE_MAP

  mount_uploader :avatar, DefaultAvatarUploader

  validates :gender, allow_blank: true, presence: false, 
             inclusion: { in: User::VALID_GENDERS }

  def persisted?
    false
  end

  def save
  	self.store_avatar!
  end

#  def id
#  	1
#  end

end