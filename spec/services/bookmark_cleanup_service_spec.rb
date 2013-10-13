require 'spec_helper'

describe BookmarkCleanupService do
  fixtures :users, :accounts, :logins

  subject { described_class.new }
  let(:perform) { subject.run }
  let(:idea) { Idea.make!(:signed_off) }

  it 'delete bookmarks for old live ideas' do
    Timecop.travel(2.weeks.ago) do
      idea.update_attributes! state: IdeaStateMachine.state_value(:live)
    end

    expect { perform }.to change { User::Bookmark.count }.by(-1)
  end

  it 'ignores bookmarks for recently live ideas' do
    idea.update_attributes! state: IdeaStateMachine.state_value(:live)

    expect { perform }.not_to change { User::Bookmark.count }
  end

  it 'ignores bookmarks for non-live ideas' do
    idea
    expect { perform }.not_to change { User::Bookmark.count }
  end
end