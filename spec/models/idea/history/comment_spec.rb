require 'spec_helper'

describe Idea::History::Comment do
  fixtures :users, :ideas

  context 'comment creation' do
    let(:comment) { Comment.make! }

    it 'gets logged as history' do
      expect { comment }.to change{ described_class.count }.by(1)
    end

    it 'links back to the idea' do
      comment.idea.should == described_class.last.idea
    end
  end
end
