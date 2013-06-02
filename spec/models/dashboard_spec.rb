require 'spec_helper'

describe Dashboard do
  fixtures :users, :accounts, :logins

  # clean up idea fixtures
  before { Idea.delete_all }

  it 'requires a user' do
    expect { described_class.new }.to raise_error(ArgumentError)
  end

  context '(record methods)' do
    let(:user) { users(:abigale_balisteri) }
    subject { described_class.new user:user }
    let(:method_name) {
      # pick up the method name from the enclosing group description
      target = example.example_group
      target = target.parent while target.description !~ /^#/
      target.description.sub(/^#/, '').to_sym
    }
    let(:result) { subject.send(method_name) }

    shared_examples_for 'empty by default' do
      it { result.should be_empty }
    end

    describe '#ideas_to_size' do
      it_should_behave_like 'empty by default'

      it 'lists sizeable ideas' do
        user.plays! :architect
        Idea.make!(development_size: nil)
        result.should_not be_empty
      end
    end

    describe '#ideas_recently_active' do
      it_should_behave_like 'empty by default'

      it 'lists recently active ideas' do
        @idea1 = Idea.make!
        @idea2 = Idea.make!
        @idea1.update_column :active_at, 1.day.ago
        @idea2.update_column :active_at, 1.hour.ago
        result.should == [@idea2, @idea1]
      end
    end

    describe '#ideas_for_dictator' do
      it_should_behave_like 'empty by default'

      it 'lists ideas needing action' do
        @idea1 = Idea.make!(:designed)
        @idea2 = Idea.make!(:implemented)
        result.should =~ [@idea1, @idea2]
      end
    end

    describe '#ideas_to_vote' do
      it_should_behave_like 'empty by default'

      it 'lists ideas needing votes' do
        User.make! # will be the author & vetter/voter
        @idea1 = Idea.make!(:vetted)
        @idea2 = Idea.make!(:voted)

        result.should =~ [@idea1, @idea2]
      end
    end

    describe '#ideas_recently_submitted' do
      it_should_behave_like 'empty by default'

      it 'lists submitted ideas' do
        @idea1 = Idea.make!(:submitted)
        @idea2 = Idea.make!(:submitted)
        @idea3 = Idea.make!(:vetted)
        result.should =~ [@idea1, @idea2]
      end
    end

    describe '#ideas_working_set' do
      it_should_behave_like 'empty by default'

      it 'lists managed ideas' do
        @idea = Idea.make!(:designed)
        @idea.update_column :product_manager_id, user.id
        result.should == [@idea]
      end
    end

    describe '#notifications_recent' do
      it_should_behave_like 'empty by default'

      it 'lists notifications' do
        @notification = Notification::NewUser.create!(recipient:user, subject:user)
        result.should == [@notification]
      end
    end

    describe '#comments_on_followed_ideas' do
      it_should_behave_like 'empty by default'

      it 'lists comments' do
        @comment = Comment.make!
        result.should == [@comment]
      end
    end
  end
end
