require 'spec_helper'

describe User do
  it "should not be valid by default" do
    User.new.should_not be_valid
  end
end
