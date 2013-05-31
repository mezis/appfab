# encoding: UTF-8
require 'spec_helper'

describe UserRolesController do
  login_user
  render_views

  let(:user) { users(:abigale_balisteri) }

  it "create action should redirect when model is invalid" do
    User::Role.any_instance.stub(:valid? => false)
    post :create, :user_id => user.id
    response.should redirect_to(user_path(user))
  end

  it "create action should redirect when model is valid" do
    User::Role.any_instance.stub(:valid? => true)
    post :create, :user_id => user.id
    response.should redirect_to(user_path(user))
  end

  it "destroy action should destroy model and redirect to index action" do
    user_role = User::Role.make! user:user
    delete :destroy, :id => user_role, :user_id => user.id
    response.should redirect_to(user_path(user))
    User::Role.exists?(user_role.id).should be_false
  end
end
