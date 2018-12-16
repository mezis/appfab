class Search
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :query, :scope

  def initialize(scope: , query: nil)
    @scope = scope || Idea
    @query = query
  end

  def ideas
    scope.basic_search(query)
  end

  def persisted?

  end
end
