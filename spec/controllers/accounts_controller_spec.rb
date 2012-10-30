require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Account.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Account.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Account.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(account_url(assigns[:account]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Account.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Account.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Account.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Account.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Account.first
    response.should redirect_to(account_url(assigns[:account]))
  end

  it "destroy action should destroy model and redirect to index action" do
    account = Account.first
    delete :destroy, :id => account
    response.should redirect_to(accounts_url)
    Account.exists?(account.id).should be_false
  end
end
