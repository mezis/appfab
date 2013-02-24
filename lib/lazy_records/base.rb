require 'lazy_records/cache'

module LazyRecords::Base
  def cache_for(model)
    @cache ||= {}
    @cache[model] ||= LazyRecords::Cache.new(model)
  end

  def flush
    @cache = {}
  end
end
