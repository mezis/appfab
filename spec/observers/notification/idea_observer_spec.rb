# encoding: UTF-8
require 'spec_helper'

describe Notification::IdeaObserver do
  let(:author)  { User.make! }
  let(:idea) { Idea.make!(blueprint.to_sym, author: author) }

  before { author }

  context 'when an idea is submitted' do
    let(:blueprint) { :submitted }

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


  context '(participants)' do
    before do
      @participant = User.make!
      Idea.any_instance.stub participants: [@participant]
    end

    context 'when an idea becomes vetted' do
      let(:blueprint) { :sized }

      it 'notifies participants' do
        idea.vettings.make! user: User.make!
        idea.vettings.make! user: User.make!
        idea.reload.state_machine.should be_vetted
        Notification::Idea::Vetted.where(recipient_id: @participant.id).count.should == 1
      end
    end

    context 'when an idea becomes picked' do
      let(:blueprint) { :voted }

      it 'notifies participants' do
        idea
        lambda {
          idea.update_attributes! state: IdeaStateMachine.state_value(:picked)
        }.should change(@participant.notifications, :count).by(1)
      end
    end

    context 'when an idea goes live' do
      let(:blueprint) { :signed_off }

      it 'notifies participants' do
        idea
        lambda {
          idea.update_attributes! state: IdeaStateMachine.state_value(:live)
        }.should change(@participant.notifications, :count).by(1)
      end
    end
  end
end
