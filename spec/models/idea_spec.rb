require 'spec_helper'

describe Idea do
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
end
