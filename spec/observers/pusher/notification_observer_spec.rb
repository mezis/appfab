require 'spec_helper'

describe Pusher::UserObserver do
  fixtures :users, :logins, :accounts

  let(:user) { users(:abigale_balisteri) }

  describe '#after_create' do
    it 'notifies Pusher' do
      Pusher.should_receive(:trigger)
      user.notifications.create! subject:user
    end
  end
end