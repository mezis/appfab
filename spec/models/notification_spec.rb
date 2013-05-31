# encoding: UTF-8
require 'spec_helper'

describe Notification::Base do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    described_class.new.should_not be_valid
  end
end
