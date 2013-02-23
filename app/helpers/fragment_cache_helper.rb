require 'digest'

module FragmentCacheHelper

  # Options:
  # - any options valid for Rails.cache.fetch
  # - v:        cache version (increment to invalidate)
  # - resource: class (mandatory)
  # - id:       identifier for the represented resource (mandatory)
  # - key:      a non-nested hash (optional)
  def cached_fragment(options = {}, &block)
    raise ArgumentError unless options[:resource] && options[:id]

    cache_options = options.slice!(:resource, :id, :v, :key)
    version       = options.fetch(:v, 1)
    cache_key     = normalize_cache_key options.fetch(:key, [])

    digest        = Digest::SHA1.hexdigest cache_key
    cache_entry   = "#{__method__}/v#{version}/#{options[:resource]}/#{options[:id]}/#{digest}"

    Rails.logger.info("cache key: #{options[:key].inspect} => #{cache_key}")
    Rails.cache.fetch(cache_entry, cache_options) { capture(&block) }
  end

  private

  def normalize_cache_key(array)
    array.map do |item|
      case item
      when String then item
      when NilClass then 'null'
      when Fixnum, TrueClass, FalseClass then item.to_s
      when Time, DateTime, ActiveSupport::TimeWithZone then item.utc.to_i
      else raise ArgumentError.new("unsupported #{item.class} in cache key")
      end
    end.join(',')
  end

end
