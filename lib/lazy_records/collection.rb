require 'lazy_records/cache'

class LazyRecords::Collection
  attr_reader :cache, :ids

  delegate :length, :size, :count, to: :ids

  def initialize(model, options={})
    @cache = LazyRecords.cache_for(model)
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


  private

  def iterator(&block)
    lambda do |id|
      block.call cache.get(id)
    end
  end

  def record_for(id)
    cache.get(id)
  end
end