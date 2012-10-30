require 'spec_helper'

describe Notification do
  it "should be valid" do
    Notification.new.should be_valid
  end
end
