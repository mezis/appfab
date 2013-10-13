# encoding: UTF-8
require 'spec_helper'

describe VotesController do
  fixtures :ideas

  login_user
  render_views

  context '(vote on ideas)' do
    let(:idea) { ideas(:idea_submitted) }
    let(:vote) { Vote.make! subject:idea }

    before { idea.update_column :state, IdeaStateMachine.state_value(:vetted) }

    describe '#create' do
      it "redirects to idea when model is invalid" do
        Vote.any_instance.stub(:valid? => false)
        post :create, :idea_id => idea.id
        response.should redirect_to(idea_path(idea))
      end
    end

    describe '#destroy' do
      it "destroys vote" do
        delete :destroy, :id => vote, :idea_id => idea.id
        Vote.exists?(vote.id).should be_false
      end

      it "redirects to idea" do
        delete :destroy, :id => vote, :idea_id => idea.id
        response.should redirect_to(idea_path(idea))
      end
    end
  end

  context '(vote on comments)' do
    let(:idea) { ideas(:idea_submitted) }
    let(:comment) { Comment.make!(author:User.make!) }

    describe '#create' do
      it "redirects to the idea" do
        post :create, :comment_id => comment.id
        response.should redirect_to(idea_path(comment.idea))
      end

      it "creates a vote" do
        lambda {
          post :create, :comment_id => comment.id
        }.should change { comment.votes.count }.by(1)
      end

      it "prevents self-votes" do
        comment.update_column :author_id, @current_user.id
        post :create, :comment_id => comment.id
        response.should be_forbidden
      end

      it "parses voting direction" do
        post :create, :comment_id => comment.id, vote: { up: 'false' }
        Vote.last.up.should be_false
      end
    end
  end
end
