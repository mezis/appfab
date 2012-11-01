require 'spec_helper'

describe Vetting do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    Vetting.new.should_not be_valid
  end

  context 'given anunsized idea' do
    before do
      @idea = Idea.make!
    end

    it 'cannot be created' do
      @user = User.make!.plays!(:product_manager)
      @user.vettings.build(idea: @idea).should_not be_valid
    end
  end

  context 'given a sized idea' do
    before do
      @idea = Idea.make!(:sized)
    end

    it 'can be created by a PM' do
      @user = User.make!.plays!(:product_manager)
      @user.vettings.create!(idea: @idea)
    end

    it 'cannot be created twice by the same user' do
      @idea.author.vettings.create!(idea: @idea)
      @idea.author.vettings.build(idea: @idea).should_not be_valid
    end
  end
end
