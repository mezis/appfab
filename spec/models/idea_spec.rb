# encoding: UTF-8
require 'spec_helper'

describe Idea do
  fixtures :users, :accounts, :logins

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

  context 'given a submitted idea' do
    
    let(:idea) { Idea.make!(:submitted) }

    it 'does not become vetted when just sized' do
      idea.update_attributes! design_size:1, development_size:1
      idea.reload.state_machine.should_not be_vetted
    end

    it 'does not become vetted when just vetted twice' do
      2.times { Vetting.make!(idea: idea, user: User.make!) }
      idea.reload.state_machine.should_not be_vetted
    end

    it 'becomes "vetted" when vetted twice then sized' do
      2.times { Vetting.make!(idea: idea, user: User.make!) }
      idea.reload.update_attributes! design_size:1, development_size:1
      idea.reload.state_machine.should be_vetted
    end

    it 'can be graveyarded' do
      IdeaStateMachineService.new(idea).trigger!(:bury)
      idea.reload.state_machine.should be_graveyarded
    end

    to_the_graveyard = IdeaStateMachine.state_names-[:implemented, :signed_off, :live, :archived, :graveyarded]
    to_the_graveyard.each do |allowed_state|
      let(:idea) { Idea.make!(allowed_state) }
      it "can be graveyarded from #{allowed_state}" do
        IdeaStateMachineService.new(idea).trigger!(:bury)
        idea.reload.state_machine.should be_graveyarded
      end
    end

    [:implemented, :signed_off, :live, :archived].each do |disallowed_state|
      let(:idea) { Idea.make!(disallowed_state) }
      it "can be archived from #{disallowed_state}" do
        IdeaStateMachineService.new(idea).trigger!(:bury)
        idea.reload.state_machine.should_not be_archived
      end
    end
  end

  describe '.counts_per_state' do
    let(:scope) { described_class }
    let(:result) { scope.counts_per_state }

    before do
      Idea.delete_all # Clear fixtures
    end

    it 'is empty when no ideas' do
      result.should be_empty
    end

    context 'with ideas' do
      before do
        2.times { Idea.make!(:vetted) }
        1.times { Idea.make!(:submitted) }
      end

      it 'counts multiples' do
        result[:vetted]   .should == 2
        result[:submitted].should == 1
        result[:picked]   .should be_nil
      end

      context 'with other scope' do
        let(:scope) { Idea.with_state(:submitted) }

        it 'respects scope' do
          result.should == { submitted: 1 }
        end
      end
    end
  end

  describe '.limit_per_state' do
    before { Idea.delete_all }
    let(:result) { Idea.limit_per_state }

    it 'returns a relation' do
      result.should be_a_kind_of(ActiveRecord::Relation)
    end

    it 'returns nothing when no ideas' do
      result.should be_empty
    end

    it 'returns a mapping when ideas present' do
      2.times { Idea.make!(state: 0) }
      1.times { Idea.make!(state: 2) }
      result.to_a.map(&:state).sort.should == [0, 0, 2]
    end
  end

  describe '(sort orders)' do
    before { Idea.delete_all }

    describe '.by_impact' do
      it 'takes sizing and rating into account' do
        idea1 = Idea.make!(design_size:2, development_size:2, rating:1)
        idea2 = Idea.make!(design_size:3, development_size:3, rating:6)

        described_class.by_impact.to_a.should == [idea2, idea1]
      end

      it 'puts unsized ideas at the end' do
        idea1 = Idea.make!(design_size:nil, development_size:nil, rating:0)
        idea2 = Idea.make!(design_size:2,   development_size:2,   rating:1)

        described_class.by_impact.to_a.should == [idea2, idea1]
      end
    end
  end
end
