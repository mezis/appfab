class DashboardsController < ApplicationController
  include Traits::RequiresLogin

  def show
    @dashboard = Dashboard.new user:current_user
  end
end
