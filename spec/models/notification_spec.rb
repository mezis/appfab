require 'spec_helper'

describe Notification do
  it "should not be valid by default" do
    Notification::Base.new.should_not be_valid
  end
end
