source 'https://rubygems.org'

gem 'rails'

# database
gem 'mysql2',  :group => :development
gem 'pg',      :group => :production

# authentication/authorisation
gem 'devise'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'cancan'

# templates
gem 'haml-rails'

# caching
gem 'memcache-client'

# i18n
gem 'gettext_i18n_rails'
gem 'gettext',     :require => false, :group => :development
gem 'ruby_parser', :require => false, :group => :development

# centralized configuration
gem 'configatron'

# syntax sugar
gem 'andand'

# Access attribute values directly, without instantiating ActiveRecord objects
# (until Rails 3.2 and #pluck)
gem 'valium'

# as name implies
gem 'state_machine'
gem 'default_value_for'

# attached files & image manipulation
gem 'dragonfly'

# caching, at the Rack level
gem 'rack-cache', :require => 'rack/cache'

# user avatars
gem 'gravtastic'

# monitoring
gem 'newrelic_rpm', :group => :production


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # styling
  gem 'compass-rails'
  gem 'bootstrap-sass'
  gem 'font-awesome-sass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development do
  # better generators
  gem 'nifty-generators'

  # debugging
  gem 'debugger'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'

  # deployment
  gem 'capistrano'

  # tdd
  gem 'rspec-rails'
  gem 'cucumber-rails',   :require => false
  gem 'capybara-webkit'
  gem 'machinist',        :require => false
  gem 'database_cleaner'
  gem 'faker',            :require => false
  gem 'launchy',          :require => false # for capybara's save_and_open_page

  # automated testing
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-rails'
  gem 'guard-bundler'
  gem 'guard-migrate'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'ruby_gntp'
  gem 'terminal-notifier-guard'

  # heroku interaction
  gem 'taps'
end
