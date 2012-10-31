require 'spec_helper'

describe Notification::VettingObserver do
  context 'when an idea is vetted' do
    before do
      @idea = Idea.make!(:sized)
      @user = User.make!.plays!(:product_manager)
    end

    it 'notifies the idea author' do
      lambda {
        @user.vettings.create!(idea: @idea)
      }.should change(@idea.author.notifications, :count).by(1) 
    end

    it 'notifies all other participants' do
      @participant = User.make!
      Idea.any_instance.stub :participants => [@participant]
      lambda {
        @user.vettings.create!(idea: @idea)
      }.should change(@participant.notifications, :count).by(1) 
    end
  end
end
