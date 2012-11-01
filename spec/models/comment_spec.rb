require 'spec_helper'

describe Comment do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should be valid" do
    Comment.new.should be_valid
  end
end
