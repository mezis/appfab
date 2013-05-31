require 'spec_helper'
require 'digest'

describe Attachment do
  fixtures :users

  let(:user) { users(:abigale_balisteri) }

  before(:all) do
    @image_data = File.read('spec/assets/image.jpg')
    @image_hash = Digest::MD5.hexdigest(@image_data)
  end

  it "should not be valid by default" do
    Attachment.new.should_not be_valid
  end

  context 'given a file blob' do
    before do
      @file = Tempfile.new('spec.jpg')
      @file.write @image_data
    end

    after do
      @file.unlink
    end

    let(:attachment) { Attachment.new owner:user, uploader:user, file:@file }

    it 'can save files' do
      attachment.save!
    end

    it 'can retrieve files' do
      attachment.save!
      digest = Digest::MD5.hexdigest(Attachment.last.file.data)
      digest.should == @image_hash
    end
  end
end
