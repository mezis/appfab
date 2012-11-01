require 'spec_helper'

describe AttachedFilesController do
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    require 'pry' ; require 'pry-nav' ; binding.pry
    get :show, :id => AttachedFile.make!
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    AttachedFile.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    AttachedFile.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(attached_file_url(assigns[:attachment]))
  end

  it "edit action should render edit template" do
    get :edit, :id => AttachedFile.make!
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    attachment = AttachedFile.make!
    AttachedFile.any_instance.stub(:valid? => false)
    put :update, :id => attachment
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => AttachedFile.make!
    response.should redirect_to(attached_file_url(assigns[:attachment]))
  end

  it "destroy action should destroy model and redirect to index action" do
    attachment = AttachedFile.make!
    delete :destroy, :id => attachment
    response.should redirect_to(attached_files_url)
    AttachedFile.exists?(attachment.id).should be_false
  end
end
