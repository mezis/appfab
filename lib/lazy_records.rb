module LazyRecords
  VERSION = '0.0.1'

  require 'lazy_records/base'
  require 'lazy_records/cache'
  require 'lazy_records/collection'
  require 'lazy_records/model'
  require 'lazy_records/flusher'

  extend LazyRecords::Base
end
