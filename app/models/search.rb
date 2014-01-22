class Search
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :query

  def initialize(query = nil)
    @query = query
  end

  def ideas
    Idea.basic_search(query)
  end
end
