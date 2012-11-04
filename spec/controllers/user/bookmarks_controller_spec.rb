require 'spec_helper'

describe User::BookmarksController do
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => User::Bookmark.make!
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    User::Bookmark.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    User::Bookmark.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(user_bookmark_url(assigns[:user_bookmark]))
  end

  it "edit action should render edit template" do
    get :edit, :id => User::Bookmark.make!
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    bookmark = User::Bookmark.make!
    User::Bookmark.any_instance.stub(:valid? => false)
    put :update, :id => bookmark
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => User::Bookmark.make!
    response.should redirect_to(user_bookmark_url(assigns[:user_bookmark]))
  end

  it "destroy action should destroy model and redirect to index action" do
    user_bookmark = User::Bookmark.make!
    delete :destroy, :id => user_bookmark
    response.should redirect_to(user_bookmarks_url)
    User::Bookmark.exists?(user_bookmark.id).should be_false
  end
end
