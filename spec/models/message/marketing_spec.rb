require 'spec_helper'

describe Message::Marketing do
  fixtures :users

  it 'validates all locales are present in summary' do
    message = described_class.new summary:{ 'fr' => 'foobar' } # 'en' locale missing
    message.should_not be_valid
  end

  describe 'notify!' do
    let(:options) { Hash.new }
    subject { described_class.make!(options) }

    context 'creates notifications' do
      it 'to all' do
        user1 = User.make!
        user2 = User.make!

        subject.notify! :all
        Notification::MarketingMessage.where(recipient_id:user1).count.should == 1
        Notification::MarketingMessage.where(recipient_id:user2).count.should == 1
      end

      it 'to a user' do
        user = User.make!
        expect { subject.notify! user }.
        to change { Notification::MarketingMessage.where(recipient_id:user).count }.
        by 1
      end

      it 'to an account' do
        user = User.make!

        expect { subject.notify! user.account }.
        to change { Notification::MarketingMessage.where(recipient_id:user).count }.
        by 1
      end
    end

    it 'is idempotent' do
      user = User.make!

      expect { 2.times { subject.notify! user } }.
      to change { Notification::MarketingMessage.where(recipient_id:user).count }.
      by 1
    end
  end
end
