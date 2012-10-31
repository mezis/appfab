require 'spec_helper'

describe Vetting do
  it "should not be valid by default" do
    Vetting.new.should_not be_valid
  end

  it 'can be created by a PM'
  it 'can be created by an architect'
  it 'cannot be created by other roles'
  it 'can only be done once by a PM'
  it 'can only be done once by an architect'
  it 'triggers notification to the idea author'
  it 'triggers notifications to participants'
end
