require 'lazy_records/collection'

module LazyRecords::Model
  def lazy_collection_of(model, options)
    LazyRecords::Collection.new(model, options)
  end
end
