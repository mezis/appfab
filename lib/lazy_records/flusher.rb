module LazyRecords::Flusher
  def self.included(by)
    by.class_eval do
      before_filter :flush_request_cache
    end
  end

  def flush_request_cache
    LazyRecords.flush
  end
end
