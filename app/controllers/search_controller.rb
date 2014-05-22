# encoding: UTF-8
class SearchController < ApplicationController
  include Traits::RequiresLogin

  before_filter :require_account!

  def index
    @search = Search.new(
      scope: current_account.ideas, 
      query: search_params[:query])
  end


  private

  def search_params
    @_search_params ||= params.require(:search).permit(:query)
  end
end
