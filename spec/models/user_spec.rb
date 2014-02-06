# encoding: UTF-8
require 'spec_helper'

describe User do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    described_class.new.should_not be_valid
  end

  it "should receive daily digest by default" do
    described_class.make.receives_digest.should be_true
  end

  describe 'scopes' do
    describe 'receives_digest' do
      subject { User.receives_digest }
      let(:user_digest_true) { described_class.make! }
      let(:user_digest_false) { described_class.make!(receives_digest: false) }

      it { should include(user_digest_true) }
      it { should_not include(user_digest_false) }
    end
  end

  describe '.create' do
    it 'sets a default karma' do
      described_class.make!.karma.should == 20
    end
  end
end
