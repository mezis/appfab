# encoding: UTF-8
class SearchController < ApplicationController
  include Traits::RequiresLogin

  before_filter :require_account!

  def index
    @search = Search.new(
      scope: current_account.ideas, 
      query: params[:search].fetch(:query, nil))
  end
end
