# encoding: UTF-8
require 'spec_helper'

describe Notification::CommentObserver do
  context 'when a new comment is posted' do
    let(:idea) { Idea.make! }
    let(:comment) { Comment.make!(idea: idea) }

    it 'notifies idea participants' do
      @user = User.make!
      Idea.any_instance.stub participants: [@user]
      lambda { comment }.should change(@user.notifications, :count).by(1)
    end

    it 'does not notify anyone else' do
      Idea.any_instance.stub participants: []
      lambda { comment }.should_not change(Notification::NewComment, :count)
    end
  end
end
