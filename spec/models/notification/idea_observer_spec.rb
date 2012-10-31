require 'spec_helper'

describe Notification::IdeaObserver do
  context 'when an idea is submitted' do
    let(:idea) { Idea.make! }

    it 'notifies product managers' do
      @user = User.make!.plays!(:product_manager)
      lambda { idea }.should change(@user.notifications, :count).by(1)
    end

    it 'notifies architects' do
      @user = User.make!.plays!(:architect)
      lambda { idea }.should change(@user.notifications, :count).by(1)
    end

    it 'does not notify anyone else' do
      @user = User.make!
      lambda { idea }.should_not change(Notification::Base, :count)
    end
  end
end
