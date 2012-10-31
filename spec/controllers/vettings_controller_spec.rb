require 'spec_helper'

describe VettingsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Vetting.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Vetting.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Vetting.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(vetting_url(assigns[:vetting]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Vetting.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Vetting.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Vetting.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Vetting.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Vetting.first
    response.should redirect_to(vetting_url(assigns[:vetting]))
  end

  it "destroy action should destroy model and redirect to index action" do
    vetting = Vetting.first
    delete :destroy, :id => vetting
    response.should redirect_to(vettings_url)
    Vetting.exists?(vetting.id).should be_false
  end
end
