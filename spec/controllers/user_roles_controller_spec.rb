require 'spec_helper'

describe UserRolesController do
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => UserRole.make!
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    UserRole.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    UserRole.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(user_role_url(assigns[:user_role]))
  end

  it "edit action should render edit template" do
    get :edit, :id => UserRole.make!
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    user_role = UserRole.make!
    UserRole.any_instance.stub(:valid? => false)
    put :update, :id => user_role
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => UserRole.make!
    response.should redirect_to(user_role_url(assigns[:user_role]))
  end

  it "destroy action should destroy model and redirect to index action" do
    user_role = UserRole.make!
    delete :destroy, :id => user_role
    response.should redirect_to(user_roles_url)
    UserRole.exists?(user_role.id).should be_false
  end
end
