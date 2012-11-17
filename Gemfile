source 'https://rubygems.org'
ruby '1.9.2'

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
gem 'state_machine', :require => false
gem 'default_value_for'

# attached files & image manipulation
gem 'dragonfly'
gem 'fileuploader-rails'

# caching, at the Rack level
gem 'rack-cache', :require => 'rack/cache'

# user avatars
gem 'gravtastic', :require => false

# monitoring
gem 'newrelic_rpm', :group => :production


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

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
  gem 'nifty-generators', :require => false

  # debugging
  gem 'pry',              :require => false
  gem 'pry-nav',          :require => false
  gem 'pry-rails'
  gem 'ruby-prof',        :require => false

  # tdd
  gem 'rspec-rails',      :require => false
  gem 'cucumber-rails',   :require => false
  gem 'capybara-webkit',  :require => false
  gem 'machinist',        :require => false
  gem 'database_cleaner', :require => false
  gem 'faker',            :require => false
  gem 'launchy',          :require => false # for capybara's save_and_open_page

  # automated testing
  gem 'guard',            :require => false
  gem 'guard-rspec',      :require => false
  gem 'guard-cucumber',   :require => false
  gem 'guard-rails',      :require => false
  gem 'guard-bundler',    :require => false
  gem 'guard-migrate',    :require => false
  gem 'rb-inotify',       :require => false
  gem 'rb-fsevent',       :require => false
  gem 'rb-fchange',       :require => false
  gem 'ruby_gntp',        :require => false
  gem 'terminal-notifier-guard', :require => false

  # heroku interaction
  gem 'taps',             :require => false
end
