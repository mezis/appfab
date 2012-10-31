require 'spec_helper'

describe Idea do
  it "should not be valid with defaults" do
    Idea.new.should_not be_valid
  end
end
