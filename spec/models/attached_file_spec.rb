require 'spec_helper'

describe AttachedFile do
  let(:user) { User.make! }

  it "should not be valid by default" do
    AttachedFile.new.should_not be_valid
  end

  context 'given a file blob' do
    before do
      @file = Tempfile.new('spec')
      @file.write 'fubar'
    end

    after do
      @file.unlink
    end

    let(:attachment) { AttachedFile.new owner:user, uploader:user, file:@file }

    it 'can save files' do
      attachment.save!
    end

    it 'can retrieve files' do
      attachment.save!
      # require 'pry' ; require 'pry-nav' ; binding.pry
      AttachedFile.last.file.data.should == 'fubar'
    end
  end
end
