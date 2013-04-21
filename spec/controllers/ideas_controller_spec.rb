# encoding: UTF-8
require 'spec_helper'

describe IdeasController do
  login_user
  render_views


  describe '#index' do
    it "renders index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe '#show' do
    it "renders show template" do
      get :show, :id => Idea.make!
      response.should render_template(:show)
    end

    it "switches to the idea account as necessary" do
      user = User.make!
      sign_in user.login

      other_account = Account.make!
      other_user    = user.login.users.create! account:other_account
      idea          = Idea.make! author:other_user

      get :show, id:idea
      response.should be_success
      flash[:account_switch].should_not be_blank
    end
  end

  describe '#new' do
    it "renders new template" do
      @current_user.plays! :submitter
      get :new
      response.should render_template(:new)
    end

    it 'redirects if not submitter' do
      get :new
      response.status.should == 302
    end
  end

  describe '#create' do
    it "renders new template when model is invalid" do
      @current_user.plays! :submitter
      Idea.any_instance.stub(:valid? => false)
      post :create
      response.should render_template(:new)
    end
  end

  describe '#edit' do
    it "renders edit template" do
      get :edit, :id => Idea.make!
      response.should render_template(:edit)
    end
  end

  describe '#update' do
    it "renders edit template when model is invalid" do
      idea = Idea.make!
      Idea.any_instance.stub(:valid? => false)
      put :update, :id => idea.id
      response.should render_template(:edit)
    end

    it "redirects when model is valid" do
      put :update, :id => Idea.make!
      response.should redirect_to(idea_url(assigns[:idea]))
    end

    it "causes the idea to be bookmarked" do
      idea = Idea.make!(author: User.make!)
      @current_user.bookmarked_ideas.should_not include(idea) # sanity check
      put :update, :id => idea
      @current_user.bookmarked_ideas.reload.should include(idea)
    end
  end

  describe '#destroy' do
    it "destroy action should destroy model and redirect to index action" do
      idea = Idea.make!
      delete :destroy, :id => idea
      response.should redirect_to(ideas_url)
      Idea.exists?(idea.id).should be_false
    end
  end

end
