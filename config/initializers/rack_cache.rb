# Rack::Cache configuration
memcached_url = case Rails.env
when 'development'
  'memcached://127.0.0.1:11211/rack-cache'
when 'test'
  'heap:/'
else
  "memcached://%<user>s:%<password>s@%<host>s/rack-cache" % {
    host:     ENV['MEMCACHIER_SERVERS'].split(',').first,
    user:     ENV['MEMCACHIER_USERNAME'],
    password: ENV['MEMCACHIER_PASSWORD']
  }
end

AppFab::Application.config.middleware.insert 0, 'Rack::Cache', {
  :metastore   => memcached_url,
  :entitystore => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body"),
  :verbose     => false,
}

