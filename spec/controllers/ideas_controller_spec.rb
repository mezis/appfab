# encoding: UTF-8
require 'spec_helper'

describe IdeasController do
  login_user
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Idea.make!
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Idea.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "edit action should render edit template" do
    get :edit, :id => Idea.make!
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    idea = Idea.make!
    Idea.any_instance.stub(:valid? => false)
    put :update, :id => idea.id
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => Idea.make!
    response.should redirect_to(idea_url(assigns[:idea]))
  end

  it "destroy action should destroy model and redirect to index action" do
    idea = Idea.make!
    delete :destroy, :id => idea
    response.should redirect_to(ideas_url)
    Idea.exists?(idea.id).should be_false
  end

  it "update action should cause the idea to be bookmarked" do
    idea = Idea.make!(author: User.make!)
    @current_user.bookmarked_ideas.should_not include(idea) # sanity check
    put :update, :id => idea
    @current_user.bookmarked_ideas.reload.should include(idea)
  end

end
