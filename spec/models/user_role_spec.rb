require 'spec_helper'

describe UserRole do
  it "should not be valid by default" do
    UserRole.new.should_not be_valid
  end

  it 'does not allow duplicates' do
    @user = User.make!
    @user.roles.create!(name:'developer')
    @user.roles.build(name:'developer').should_not be_valid
  end
end
