require 'dragonfly'

Dragonfly[:files].tap do |dragonfly_app|
  dragonfly_app.configure_with(:imagemagick)
  dragonfly_app.configure_with(:rails)
  dragonfly_app.define_macro(ActiveRecord::Base, :file_accessor)
  dragonfly_app.datastore = Storage::DataStore.new
  dragonfly_app.configure do |config|
    config.identify_command = "identify -quiet"
  end
end

memcached_url = case Rails.env
when 'development', 'test'
  'memcached://localhost:11211/rack-cache'
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

AppFab::Application.config.middleware.insert_after 'Rack::Cache', 
  'Dragonfly::Middleware', :files
