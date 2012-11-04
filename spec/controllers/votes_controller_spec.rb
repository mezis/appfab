# encoding: UTF-8
require 'spec_helper'

describe VotesController do
  login_user
  render_views

  let(:idea) { Idea.make! }
  let(:vote) { Vote.make! subject:idea }

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
end
