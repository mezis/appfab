# encoding: UTF-8
require 'spec_helper'

describe VotesController do
  fixtures :ideas

  login_user
  render_views

  context '(vote on ideas)' do
    let(:idea) { ideas(:idea_submitted) }
    let(:vote) { Vote.make! subject:idea }
    let(:comment) { Comment.make! }

    it "create action should render new template when model is invalid" do
      Vote.any_instance.stub(:valid? => false)
      post :create, :idea_id => idea.id
      response.should redirect_to(idea_path(idea))
    end

    it "destroy action should destroy model and redirect to index action" do
      delete :destroy, :id => vote, :idea_id => idea.id
      response.should redirect_to(idea_path(idea))
      Vote.exists?(vote.id).should be_false
    end

    it "works on comments" do
      lambda {
        post :create, :comment_id => comment.id
      }.should change { comment.votes.count }.by(1)
    end

    it "parses voting direction" do
      post :create, :comment_id => comment.id, vote: { up: 'false' }
      Vote.last.up.should be_false
    end

  end
end
