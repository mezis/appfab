require 'spec_helper'

describe User::Bookmark do
  it "should be valid" do
    User::Bookmark.new.should be_valid
  end
end
