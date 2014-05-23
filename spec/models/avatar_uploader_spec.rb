require 'spec_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:user) { FactoryGirl.create(:user_with_avatar) }

  before do
    AvatarUploader.enable_processing = true
    @uploader = user.avatar
  end


  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the large version' do
    describe "should scale down an image to fit 200 by 200 pixels" do
      specify { expect(@uploader.large).to be_no_larger_than(200, 200) }
    end
  end

  context 'the medium version' do
    describe "should scale down an image to fit within 100 by 100 pixels" do
      specify { expect(@uploader.medium).to be_no_larger_than(100, 100) }
    end
  end

  context 'the small version' do
    describe "should scale down an image to fit within 60 by 60 pixels" do
      specify { expect(@uploader.small).to be_no_larger_than(60, 60) }
    end
  end

  context 'the tiny version' do
    describe "should scale down an image to fit within 30 by 30 pixels" do
      specify { expect(@uploader.tiny).to be_no_larger_than(30, 30) }
    end
  end

  describe "should make the image readable only to the owner and not executable" do
    specify { expect(@uploader).to have_permissions(0600) }
  end
end