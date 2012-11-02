# encoding: UTF-8
require 'spec_helper'

describe CommentsController do
  login_user
  render_views

  it "create action should redirect to idea list when model is invalid" do
    Comment.any_instance.stub(:valid? => false)
    post :create
    response.should redirect_to(ideas_path)
  end

  it "update action should redirect to idea when model is invalid" do
    comment = Comment.make!
    Comment.any_instance.stub(:valid? => false)
    put :update, :id => comment.id
    response.should redirect_to(idea_path(comment.idea))
  end

  it "update action should redirect to idea when model is valid" do
    put :update, :id => Comment.make!
    response.should redirect_to(idea_path(Comment.last.idea))
  end

  it "destroy action should destroy model and redirect to idea action" do
    comment = Comment.make!
    delete :destroy, :id => comment
    response.should redirect_to(idea_url(comment.idea))
    Comment.exists?(comment.id).should be_false
  end
end
