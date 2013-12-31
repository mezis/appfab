# encoding: UTF-8
require 'spec_helper'

describe Karma::CommentObserver do
  context 'when a comment is posted' do
    fixtures :ideas, :users, :accounts, :logins

    it 'the commenter gains karma' do
      idea   = ideas(:idea_submitted)
      author = User.make!
      lambda {
        Comment.make! author: author, idea: idea
      }.should change(author, :karma).by(1)
    end
  end
end
