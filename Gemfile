source 'https://rubygems.org'

gem 'rails', '3.2.8'

# database
gem 'sqlite3' 

# authentication/authorisation
gem 'devise'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'cancan'

# templates
gem 'haml-rails'

# styling
gem 'compass'
gem 'bootstrap-sass-rails'

# caching
gem 'memcache-client'

# i18n
gem 'gettext_i18n_rails'
gem 'gettext',     :require => false, :group => :development
gem 'ruby_parser', :require => false, :group => :development

# centralized configuration
gem 'configatron'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

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
  gem 'rspec-rails',      :require => false
  gem 'cucumber-rails',   :require => false
  gem 'capybara-webkit',  :require => false
  gem 'machinist',        :require => false
  gem 'database_cleaner', :require => false
end



