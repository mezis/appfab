require 'spec_helper'

describe DashboardsController do
  fixtures :all
  render_views

  xit "show action should render show template" do
    get :show
    response.should render_template(:show)
  end
end
