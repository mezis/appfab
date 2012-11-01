# encoding: UTF-8
require 'spec_helper'

describe Idea do
  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid with defaults" do
    Idea.new.should_not be_valid
  end

  it 'links to the author account' do
    @idea = Idea.make!
    @idea.account.should == @idea.author.account
  end

  it 'is listed in the account ideas' do
    @idea = Idea.make!
    Account.last.ideas.should include(@idea)
  end

  it 'becomes "vetted" when vetted twice' do
    @idea = Idea.make!(:sized)
    Vetting.make!(idea: @idea)
    @idea.reload.vetted?.should be_false
    Vetting.make!(idea: @idea, user: User.make!)
    @idea.reload.vetted?.should be_true
  end

  it 'cannot be picked if the manager is at design capacity' do
    @idea = Idea.make!(:vetted, design_size: 4)
    configatron.temp do
      configatron.socialp.design_capacity = 3
      @idea.can_pick»?.should be_false
    end
  end

  it 'cannot be approved if the manager is at development capacity' do
    @idea = Idea.make!(:designed, development_size: 4)
    configatron.temp do
      configatron.socialp.design_capacity = 3
      @idea.can_pick»?.should be_false
    end
  end
end
