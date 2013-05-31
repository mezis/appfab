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

    describe 'GET edit' do
      it "renders edit template" do
        get :edit, :id => user
        response.should render_template(:edit)
      end
    end

    describe 'PUT update' do
      it "renders edit template when model is invalid" do
        user
        User.any_instance.stub(:valid? => false)
        put :update, :id => user
        response.should render_template(:edit)
      end

      it "redirects when model is valid" do      
        User.any_instance.stub(:valid? => true)
        put :update, :id => user
        response.should redirect_to(user_url(assigns[:user]))
      end

      context '(state update)' do
        it 'updates user state' do
          expect {
            put :update, id:user, user:{ state:1 }
          }.to change{ user.reload.state }.from(0).to(1)
        end

        it 'fails if user not authorized' do
          @current_user.roles.delete_all
          put :update, id:user, user:{ state:1 }
          user.reload.state.should eq(0)
        end
      end
    end

    describe 'DELETE destroy' do
      it "destroy action should destroy model and redirect to index action" do
        delete :destroy, :id => user
        response.should redirect_to(users_url)
        User.exists?(user.id).should be_false
      end
    end
  end
end
