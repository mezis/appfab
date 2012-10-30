require 'spec_helper'

describe NotificationsController do
  login_user
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Notification.make!
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Notification.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Notification.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(notification_url(assigns[:notification]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Notification.make!
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    notification = Notification.make!
    Notification.any_instance.stub(:valid? => false)
    put :update, :id => notification.id
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => Notification.make!
    response.should redirect_to(notification_url(assigns[:notification]))
  end

  it "destroy action should destroy model and redirect to index action" do
    notification = Notification.make!
    delete :destroy, :id => notification
    response.should redirect_to(notifications_url)
    Notification.exists?(notification.id).should be_false
  end
end
