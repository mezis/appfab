require 'spec_helper'

describe Vote do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    Vote.new.should_not be_valid
  end
end
