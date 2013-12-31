#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake_ext/raven'

if Rails.env.development?
  begin
    require 'gettext_i18n_rails/tasks'
  rescue LoadError => e
    warn 'I18n tasks may be unavailable.'
  end
end

AppFab::Application.load_tasks
