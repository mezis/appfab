require 'spec_helper'

describe Karma::CommentObserver do
  context 'when a comment is posted' do
    let(:author)  { User.make! }
    let(:idea)    { Idea.make! }
    let(:comment) { Comment.make! author: author, idea: idea }

    it 'the commenter gains karma' do
      idea # make sure the idea is created outside the 'should' block
      lambda { comment }.should change(author, :karma).by(1)
    end
  end
end
