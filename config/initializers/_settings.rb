require 'configatron'

configatron.omniauth.google_oauth2.app_id = '829784005951.apps.googleusercontent.com'
configatron.omniauth.google_oauth2.app_secret = 'pxnPqfWV2m6DHg4XygEhOYlW'

configatron.socialp.default_karma = 10

if Rails.env.production?
  # production-specific settings
end
