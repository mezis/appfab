require 'spec_helper'

describe AttachmentsController do
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Attachment.make!
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Attachment.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Attachment.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(attachment_url(assigns[:attachment]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Attachment.make!
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    attachment = Attachment.make!
    Attachment.any_instance.stub(:valid? => false)
    put :update, :id => attachment
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    put :update, :id => Attachment.make!
    response.should redirect_to(attachment_url(assigns[:attachment]))
  end

  it "destroy action should destroy model and redirect to index action" do
    attachment = Attachment.make!
    delete :destroy, :id => attachment
    response.should redirect_to(attachments_url)
    Attachment.exists?(attachment.id).should be_false
  end
end
