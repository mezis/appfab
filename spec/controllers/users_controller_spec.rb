require 'spec_helper'

describe UsersController do
  login_user
  render_views

  let(:user) { users(:abigale_balisteri) }

  it "index action should render index template" do
    get :index
    response.should redirect_to(account_url(@current_user.account))
  end

  it "show action should render show template" do
    get :show, :id => user
    response.should render_template(:show)
  end

  context 'for an account owner' do
    before do
      @current_user.plays! :account_owner
    end

    it "edit action should render edit template" do
      get :edit, :id => user
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      user
      User.any_instance.stub(:valid? => false)
      put :update, :id => user
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do      
      User.any_instance.stub(:valid? => true)
      put :update, :id => user
      response.should redirect_to(user_url(assigns[:user]))
    end

    it "destroy action should destroy model and redirect to index action" do
      delete :destroy, :id => user
      response.should redirect_to(users_url)
      User.exists?(user.id).should be_false
    end
  end
end
