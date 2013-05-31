# encoding: UTF-8
require 'spec_helper'

describe VettingsController do
  render_views
  login_user
  
  fixtures :ideas

  let(:idea) { ideas(:idea_submitted) }
  let(:vetting) { Vetting.make! idea:idea }

  it "create action should render new template when model is invalid" do
    Vetting.any_instance.stub(:valid? => false)
    post :create,  :idea_id => idea
    response.should redirect_to(idea_path(idea))
  end

  it "create action should redirect when model is valid" do
    Vetting.any_instance.stub(:valid? => true)
    post :create,  :idea_id => idea
    response.should redirect_to(idea_path(idea))
  end

  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => vetting,  :idea_id => idea
    response.should redirect_to(idea_url(idea))
    Vetting.exists?(vetting.id).should be_false
  end
end
