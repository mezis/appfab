require 'configatron'

configatron.omniauth.google_oauth2.app_id = '829784005951.apps.googleusercontent.com'
configatron.omniauth.google_oauth2.app_secret = 'pxnPqfWV2m6DHg4XygEhOYlW'

if Rails.env.production?
  # production-specific settings
end
