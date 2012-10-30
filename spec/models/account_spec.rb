require 'spec_helper'

describe Account do
  it "should not be valid by default" do
    Account.new.should_not be_valid
  end
end
