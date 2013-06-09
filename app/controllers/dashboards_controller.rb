class DashboardsController < ApplicationController
  include Traits::RequiresLogin

  before_filter :require_account!

  def show
    @dashboard = Dashboard.new user:current_user
  end
end
