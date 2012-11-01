require 'spec_helper'

describe User do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    User.new.should_not be_valid
  end

  describe '.create' do
    it 'sets a default karma' do
      User.make!.karma.should == 20
    end

    it 'gets user adopted by an account based on email' do
      account_member = User.make!
      account_member.account.update_attributes!(auto_adopt: true)
      new_user = User.make!(email: "john@#{account_member.account.domain}")
      new_user.account.should == account_member.account
    end
  end
end

