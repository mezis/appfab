require 'configatron'

configatron.socialp.default_karma   = 10
configatron.socialp.vettings_needed = 2

if Rails.env.production?
  # production-specific settings
  configatron.omniauth.google_oauth2.app_id     = '829784005951-octuu39kre09vnkg44uen7jvr4o96rnd.apps.googleusercontent.com'
  configatron.omniauth.google_oauth2.app_secret = 'fW_q7ngOBH2ptMhpp4dvP-Rr'
else
  configatron.omniauth.google_oauth2.app_id     = '829784005951.apps.googleusercontent.com'
  configatron.omniauth.google_oauth2.app_secret = 'pxnPqfWV2m6DHg4XygEhOYlW'
end
