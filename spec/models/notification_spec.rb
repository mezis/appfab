require 'spec_helper'

describe Notification do
  it "should not be valid by default" do
    Notification.new.should_not be_valid
  end
end
