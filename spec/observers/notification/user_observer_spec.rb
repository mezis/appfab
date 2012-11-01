require 'spec_helper'

describe Notification::UserObserver do
  it 'notifies of account members' do
    account_member = User.make!
    User.make!(account: account_member.account)
    account_member.notifications.should_not be_empty
  end
end
