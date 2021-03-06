# encoding: UTF-8
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# # you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module AppFab
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app/observers)
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = %w[
        Notification::UserObserver
        Notification::VettingObserver
        Notification::CommentObserver
        Notification::IdeaObserver
        Notification::VoteObserver
        Karma::VoteOnIdeaObserver
        Karma::VoteOnCommentObserver
        Karma::CommentObserver
        Karma::IdeaObserver
        Karma::VettingObserver
        Rating::VoteObserver
        BookmarkObserver
        Pusher::UserObserver
        Pusher::NotificationObserver
    ]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '100'

    # avoid issues when deploying to heroku
    # https://devcenter.heroku.com/articles/rails3x-asset-pipeline-cedar#troubleshooting
    config.assets.initialize_on_precompile = false

    # Cache assets so the next round of compilation is faster
    config.assets.cache_store = :dalli_store

    # backing store for page/action/fragment caching
    config.cache_store = :dalli_store

    # Raise exceptions on bad locales, and default to English
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :en
  end
end
