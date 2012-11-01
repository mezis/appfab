require 'spec_helper'

describe StoredFile do
  it "should not be valid by default" do
    StoredFile.new.should_not be_valid
  end
end
