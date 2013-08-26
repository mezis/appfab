require 'spec_helper'

describe Pusher::UserObserver do
  fixtures :users, :logins, :accounts

  let(:user) { users(:abigale_balisteri) }

  describe '#after_save' do
    context 'when karma changes' do
      it 'notifies Pusher' do
        Pusher.should_receive(:trigger)
        user.karma += 1
        user.save!
      end
    end

    context 'when karma unchanged' do
      it 'does not notify Pusher' do
        Pusher.should_not_receive(:trigger)
        user.karma += 0
        user.save!
      end
    end
  end
end