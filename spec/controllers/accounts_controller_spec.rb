# encoding: UTF-8
require 'spec_helper'

describe AccountsController do
  login_user
  render_views

  before do
    @current_user.plays! :account_owner
  end

  it "show action should render show template" do
    get :show, :id => @current_user.account
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Account.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Account.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(account_url(assigns[:account]))
  end

  it "edit action should render edit template" do
    get :edit, :id => @current_user.account
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    account = @current_user.account
    Account.any_instance.stub(:valid? => false)
    put :update, :id => account.id
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => @current_user.account
    response.should redirect_to(account_url(assigns[:account]))
  end

  it "destroy action should destroy model and redirect to index action" do
    account = @current_user.account
    delete :destroy, :id => account
    response.should redirect_to(accounts_url)
    Account.exists?(account.id).should be_false

    it 'switches to another account'
  end
end
