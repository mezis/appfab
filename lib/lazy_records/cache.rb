require 'singleton'
require 'active_record'

class LazyRecords::Cache
  # class -> id -> cached record mapping
  attr_reader :records
  attr_reader :model

  # if true (the default), the first +get+ will load as much as possible
  attr :eager


  def initialize(model)
    raise ArgumentError unless model < ActiveRecord::Base
    @model    = model
    @records  = {}
    @eager    = true
    @includes = []
  end


  def get(id)
    eager_load
    @records[id] ||= model.find(id)
  end

  # notifies the cache that the +ids+ may be used in the near future
  # pass :includes to eager load associated models
  def may_need(ids, options={})
    # adds id=>nil to the known records unless present
    @records.reverse_merge! Hash[ids.zip]
    @includes += options.fetch(:includes, [])
    nil
  end

  private

  def eager_load
    missing_ids = @records.select { |id,record| record.nil? }.keys
    return if missing_ids.empty?
    Rails.logger.info("eager loading #{missing_ids.count} #{model.name.pluralize}: #{missing_ids.join(', ')}")
    scope = model.includes(@includes).where(id: missing_ids)
    @records.merge! scope.index_by(&:id)
    nil
  end
end