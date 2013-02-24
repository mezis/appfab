require 'lazy_records/collection'

module LazyRecords::Model
  def self.included(by)
    by.class_eval do
      after_save { |record| LazyRecords.flush }
    end
  end

  def lazy_collection_of(model, options)
    LazyRecords::Collection.new(model, options)
  end
end
