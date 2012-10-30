require File.dirname(__FILE__) + '/../spec_helper'

describe Vote do
  it "should be valid" do
    Vote.new.should be_valid
  end
end
