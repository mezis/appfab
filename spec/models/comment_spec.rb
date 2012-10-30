require 'spec_helper'

describe Comment do
  it "should be valid" do
    Comment.new.should be_valid
  end
end
