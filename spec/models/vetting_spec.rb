require 'spec_helper'

describe Vetting do
  it "should be valid" do
    Vetting.new.should be_valid
  end

  it 'can be created by a PM'
  it 'can be created by an architect'
  it 'cannot be created by other roles'
  it 'can only be done once by a PM'
  it 'can only be done once by an architect'
end
