source ENV.fetch('GEM_SOURCE','https://rubygems.org')
ruby '2.0.0'

gem 'rails', '~> 4.0.0'

# webservers
gem 'rainbows', group: :production
gem 'thin',     group: :development

# load .env
gem 'dotenv-rails'

# database
gem 'pg'

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

# Property API for plain classes (used for form objects)
gem 'virtus'

# activerecord extensions
gem 'state_machine', require:false
gem 'default_value_for'
gem 'rails-observers'

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

# pjax-style links without full page reloads
gem 'turbolinks'
gem 'jquery-turbolinks'

# push / websocket events
gem 'pusher'

# speeds up Travis builds by caching the bundle
gem 'bundle_cache'

# makes the app (more) 12-factor compliant
gem 'rails_12factor', group: :production

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'

# styling
gem 'sass', '~> 3.2.0'
gem 'compass-rails', '2.0.alpha.0'
gem 'bootstrap-sass'
gem "font-awesome-rails"
gem 'animation'

# asset minification
gem 'uglifier', '>= 1.0.3'


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

  # stub version of the Pusher API
  gem 'pusher-fake'

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

