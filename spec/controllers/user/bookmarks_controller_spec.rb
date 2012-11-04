require 'spec_helper'

describe User::BookmarksController do
  render_views

  xit "create action should render new template when model is invalid" do
    User::Bookmark.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  xit "create action should redirect when model is valid" do
    User::Bookmark.any_instance.stub(:valid? => true)
    post :create
    # response.should redirect_to(somewhere)
  end

  xit "destroy action should destroy model and redirect to index action" do
    user_bookmark = User::Bookmark.make!
    delete :destroy, :id => user_bookmark
    # response.should redirect_to(user_bookmarks_url)
    User::Bookmark.exists?(user_bookmark.id).should be_false
  end
end
