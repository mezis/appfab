require 'spec_helper'

describe User::BookmarksController do
  login_user
  render_views

  it "create action should redirect when model is invalid" do
    User::Bookmark.any_instance.stub(:valid? => false)
    post :create
    response.should redirect_to(ideas_path(angle: 'followed'))
  end

  it "create action should redirect when model is valid" do
    User::Bookmark.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(ideas_path(angle: 'followed'))
  end

  it "destroy action should destroy model and redirect to followed ideas" do
    idea = Idea.make!
    @current_user.bookmarks.destroy_all
    user_bookmark = @current_user.bookmarks.make! idea:idea
    delete :destroy, :id => user_bookmark
    response.should redirect_to(idea_path(idea))
    User::Bookmark.exists?(user_bookmark.id).should be_false
  end
end
