require 'lazy_records/cache'

class LazyRecords::Collection
  attr_reader :ids, :model

  delegate :length, :size, :count, to: :ids

  def initialize(model, options={})
    @model = model
    @ids   = options[:ids]
    cache.may_need ids, options.slice(:includes)
  end


  [:first, :last].each do |method_name|
    define_method method_name do
      cache.get ids.send(method_name)
    end
  end


  [:map, :select, :each].each do |method_name|
    define_method method_name do |&block|
      @ids.send(method_name, &iterator(&block))
    end
  end

  def take(count)
    cache.get @ids.take(count)
  end

  def all
    map { |x| x }
  end

  alias_method :to_a, :all


  private

  def iterator(&block)
    lambda do |id|
      block.call cache.get(id)
    end
  end

  def record_for(id)
    cache.get(id)
  end

  def cache
    LazyRecords.cache_for(model)
  end
end