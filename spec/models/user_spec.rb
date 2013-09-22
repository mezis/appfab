# encoding: UTF-8
require 'spec_helper'

describe User do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    described_class.new.should_not be_valid
  end

  describe '.create' do
    it 'sets a default karma' do
      described_class.make!.karma.should == 20
    end
  end
end
