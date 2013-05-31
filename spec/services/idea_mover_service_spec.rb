require 'spec_helper'

describe IdeaMoverService do
  subject { described_class.new(idea:@idea, account:@account) }
  let(:perform) { subject.run }

  it 'borks if missing an idea or account' do
    expect { perform }.to raise_exception(ArgumentError)
  end

  it 'borks if idea already in target account' do
    @idea    = Idea.make!
    @account = @idea.account
    expect { perform }.to raise_exception(ArgumentError)    
  end

  context '(with idea and account)' do
    before do
      @idea        = Idea.make!
      @participant = User.make!
      @old_account = @idea.account
      @account     = Account.make!
    end

    it 'changes the idea account' do
      expect { perform }.to change { Idea.last.account }.to(@account)
    end

    it 'clears the category' do
      @idea.update_column :category, 'foo'
      expect { perform }.to change { @idea.reload.category }.to(nil)
    end

    it 'creates missing users' do
      @old_author = @idea.author
      perform
      @new_author = @idea.reload.author
      @new_author.should_not     eq(@old_author)
      @new_author.account.should eq(@account)
      @new_author.login.should   eq(@old_author.login)
    end

    it 'preserves votes' do
      @vote = Vote.make!(subject:@idea, user:@participant)
      perform
      @new_participant = @vote.reload.user
      @new_participant.should_not eq(@participant)
      @new_participant.account.should eq(@account)
      @new_participant.login.should eq(@participant.login)
    end

    it 'preserves vettings' do
      @vetting = Vetting.make!(idea:@idea, user:@participant)
      perform
      @new_participant = @vetting.reload.user
      @new_participant.should_not eq(@participant)
      @new_participant.account.should eq(@account)
      @new_participant.login.should eq(@participant.login)
    end

    it 'preserves comments' do
      @comment = Comment.make!(idea:@idea, author:@participant)
      perform
      @new_participant = @comment.reload.author
      @new_participant.should_not eq(@participant)
      @new_participant.account.should eq(@account)
      @new_participant.login.should eq(@participant.login)
    end
  end
end

