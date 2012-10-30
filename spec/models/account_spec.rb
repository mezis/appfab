require 'spec_helper'

describe Account do
  it "should be valid" do
    Account.new.should be_valid
  end
end
