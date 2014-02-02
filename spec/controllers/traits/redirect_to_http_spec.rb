require 'spec_helper'

describe Traits::RedirectToHttps, :type => :controller do
  controller(ActionController::Base) do
    include Traits::RedirectToHttps

    def index
      head :ok
    end
  end

  it 'does not redirect in tests' do
    get :index
    response.status.should == 200
  end

  context 'when in staging environment' do
    around do |example|
      @former_env = Rails.env
      Rails.env = 'staging'
      example.run
      Rails.env = @former_env
    end

    it 'redirects GET to HTTPS' do
      get :index
      response.status.should == 302
      response.headers['Location'].should =~ /^https:/
    end

    it 'does not redirect HTTPS' do
      request.stub :ssl? => true
      get :index
      response.status.should == 200
    end

    it 'does not redirect POST' do
      post :index
      response.status.should == 200
    end
  end
end
