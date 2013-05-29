source 'http://rubygems.org'
ruby '2.0.0'

gem 'rails'

gem 'unicorn'

# database
gem 'mysql2',  group: :development
gem 'pg',      group: :production

# authentication/authorisation
gem 'devise'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'cancan'

# templates
gem 'haml-rails'

# caching
gem 'dalli'
gem 'memcachier'

# i18n
gem 'gettext_i18n_rails'
gem 'gettext',     require:false, group: :development
gem 'ruby_parser', require:false, group: :development

# centralized configuration
gem 'configatron'

# syntax sugar
gem 'andand'

# Access attribute values directly, without instantiating ActiveRecord objects
# (because Rails' #pluck breaks a lot with joins)
gem 'valium'

# activerecord extensions
gem 'state_machine', require:false
gem 'default_value_for'

# attached files & image manipulation
gem 'dragonfly'
gem 'fineuploader-rails'

# caching, at the Rack level
gem 'rack-cache', require:'rack/cache'

# user avatars
gem 'gravtastic', require:false

# monitoring
gem 'newrelic_rpm'

# styled user input (markdown)
gem 'redcarpet'

# a standard web UX library
gem 'jquery-rails'

# HTML email preprocessing
gem 'roadie'

# Pagination
gem 'will_paginate'

# exception reporting
gem 'sentry-raven'

# coffeescript JS views
gem 'coffee-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'

  # styling
  gem 'compass-rails'
  gem 'bootstrap-sass'
  gem 'font-awesome-sass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end


group :development do
  # better generators
  gem 'nifty-generators',        require:false

  # debugging
  gem 'pry',                     require:false
  gem 'pry-nav',                 require:false
  gem 'pry-doc',                 require:false
  gem 'pry-rails'
  gem 'ruby-prof',               require:false

  # tdd
  gem 'rspec',                   require:false
  gem 'rspec-rails',             require:false
  gem 'cucumber-rails',          require:false
  gem 'capybara',    '~> 2.0.3', require:false # locking as 2.1.0 has issues for now
  gem 'poltergeist'    ,         require:false # PhantomJS capybara driver
  gem 'machinist',               require:false
  gem 'database_cleaner',        require:false
  gem 'faker',                   require:false
  gem 'launchy',                 require:false # for capybara's save_and_open_page
  gem 'timecop'

  # automated testing
  gem 'guard',                   require:false
  gem 'guard-rspec',             require:false
  gem 'guard-cucumber',          require:false
  gem 'guard-rails',             require:false
  gem 'guard-bundler',           require:false
  gem 'guard-migrate',           require:false
  gem 'rb-inotify',              require:false
  gem 'rb-fsevent',              require:false
  gem 'rb-fchange',              require:false
  gem 'terminal-notifier-guard', require:false

  # measure test coverage
  gem 'coveralls',               require:false

  # heroku interaction
  gem 'taps',                    require:false

  # is that a DBA in your pocket, or are you just happy to see me?
  gem 'query_reviewer'

  # as says on the tin
  gem 'license_finder',          require:false

  # provides /rails/routes, built-in in Rails 4
  gem 'sextant'

  # stop logging asset request
  gem 'quiet_assets'

  # nicer error messages in the browser
  gem "better_errors"
  gem "binding_of_caller"
end

