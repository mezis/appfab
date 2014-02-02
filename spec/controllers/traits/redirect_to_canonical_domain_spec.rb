require 'spec_helper'

describe Traits::RedirectToCanonicalDomain, :type => :controller do
  controller(ActionController::Base) do
    include Traits::RedirectToCanonicalDomain

    def index
      head :ok
    end
  end

  it 'does not redirect for the app host' do
    get :index
    response.status.should == 200
  end

  context 'when addressing a different host' do
    before do
      request.host = 'host.host'
    end

    it 'redirects GET to canonical domain' do
      get :index
      response.status.should == 302
      response.headers['Location'].should =~ /test.host/
    end

    it 'redirects with HTTPS' do
      get :index
      response.headers['Location'].should =~ /^https:/
    end

    it 'does not redirect POST' do
      post :index
      response.status.should == 200
    end
  end
end
