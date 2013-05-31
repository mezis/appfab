# encoding: UTF-8
require 'spec_helper'

describe DashboardsController do
  login_user
  render_views

  it "show action should render show template" do
    get :show
    response.should render_template(:show)
  end
end
