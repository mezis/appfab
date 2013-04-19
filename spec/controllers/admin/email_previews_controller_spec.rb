require 'spec_helper'

describe Admin::EmailPreviewsController do
  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      # require 'pry' ; require 'pry-nav' ; binding.pry
      response.should be_success
    end
  end

end
