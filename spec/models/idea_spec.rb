require 'spec_helper'

describe Idea do
  it "should be valid" do
    Idea.new.should be_valid
  end
end
