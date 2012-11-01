require 'spec_helper'

describe Attachment do
  let(:user) { User.make! }

  it "should not be valid by default" do
    Attachment.new.should_not be_valid
  end

  context 'given a file blob' do
    before do
      @file = Tempfile.new('spec')
      @file.write 'fubar'
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
      Attachment.last.file.data.should == 'fubar'
    end
  end
end
