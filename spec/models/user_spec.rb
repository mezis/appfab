# encoding: UTF-8
require 'spec_helper'

describe User do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    described_class.new.should_not be_valid
  end

  describe '.create' do
    it 'sets a default karma' do
      described_class.make!.karma.should == 20
    end

    it 'gets user adopted by an account based on email' do
      # account_member = User.make!
      # account_member.account.update_attributes!(auto_adopt: true)
      account = Account.make!(domain:'example.com', auto_adopt:true)
      
      new_login = Login.make!(email: "john@example.com")
      new_login.accounts.should include(account)
    end
  end
end

