require 'digest'

module FragmentCacheHelper
  FRAGMENT_CACHE_VERSION = 0

  # Options:
  # - any options valid for Rails.cache.fetch
  # - v:        cache version (increment to invalidate)
  # - resource: class (mandatory)
  # - id:       identifier for the represented resource (mandatory)
  # - key:      a non-nested hash (optional)
  def cached_fragment(options = {}, &block)
    raise ArgumentError unless options[:resource] && options[:id]

    cache_options = options.slice!(:resource, :id, :v, :key)
    version       = options.fetch(:v, 1) + FRAGMENT_CACHE_VERSION
    key           = options.fetch(:key, [])
    key.unshift options[:resource]
    key.unshift options[:id]
    cache_key     = normalize_cache_key key
    digest        = Digest::SHA1.hexdigest cache_key
    cache_entry   = "#{__method__}/v#{version}/#{digest}"

    Rails.logger.info("Cache key: #{cache_key} -> #{digest}") if key.any?
    Rails.cache.fetch(cache_entry, cache_options) { capture(&block) }
  end

  private

  def normalize_cache_key(array)
    array.map do |item|
      case item
      when Class then item.name
      when String then item
      when NilClass then 'null'
      when Fixnum, TrueClass, FalseClass then item.to_s
      when Time, DateTime, ActiveSupport::TimeWithZone then item.utc.to_i
      else raise ArgumentError.new("unsupported #{item.class} in cache key")
      end
    end.join(',')
  end

end
