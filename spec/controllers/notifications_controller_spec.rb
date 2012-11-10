# encoding: UTF-8
require 'spec_helper'

describe NotificationsController do
  login_user
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Notification::Base.make!
    response.should render_template(:show)
  end

  it "update action should render edit template when model is invalid" do
    notification = Notification::Base.make!
    Notification::Base.any_instance.stub(:valid? => false)
    put :update, :id => notification.id
    response.should redirect_to(notifications_path)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => Notification::Base.make!
    response.should redirect_to(notifications_path)
  end

  it "destroy action should destroy model and redirect to index action" do
    notification = Notification::Base.make!
    delete :destroy, :id => notification
    Notification::Base.exists?(notification.id).should be_false
  end
end
