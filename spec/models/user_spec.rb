require 'spec_helper'

describe User do
  it "should not be valid by default" do
    User.new.should_not be_valid
  end

  describe '.create' do
    it 'sets a default karma' do
      User.make!.karma.should == 10
    end

    it 'gets user adopted by an account'

    it 'notifies of account members' do
      account_member = User.make!
      User.make!(email: "john@#{account_member.account.domain}")
      account_member.notifications.should_not be_empty
    end
  end
end
