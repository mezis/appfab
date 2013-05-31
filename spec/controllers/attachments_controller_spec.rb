require 'spec_helper'

describe AttachmentsController do
  login_user
  render_views
  
  fixtures :ideas

  let(:idea) { ideas(:idea_submitted) }

  let(:file) do
    Rack::Test::UploadedFile.new(Rails.root.join('spec/assets/image.jpg'), 'image/jpeg')
  end

  it "create action redirects if not Ajax" do
    post :create, idea_id: idea.id
    response.should redirect_to(idea_path(idea))
  end

  it "create action should render JSON when model is invalid" do
    xhr :post, :create, idea_id: idea.id, format: :json
    response.body.should == %({"success":false})
  end

  it "create action should render JSON when model is valid" do
    xhr :post, :create, idea_id: idea.id, format: :json, attachment: { file: file }
    result = JSON.parse(response.body)
    result['success'].should be_true
    result['id'].should be_a_kind_of(Integer)
  end

  it "destroy action should destroy model and redirect to idea" do
    attachment = Attachment.make! owner: idea
    delete :destroy, idea_id: idea.id, id: attachment.id
    response.should redirect_to(idea_path(idea))
    Attachment.exists?(attachment.id).should be_false
  end
end
