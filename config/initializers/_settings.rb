# encoding: UTF-8
require 'configatron'

configatron.app_name                   = 'AppFab'

configatron.socialp.karma.initial      = +20
configatron.socialp.karma.vote         = -10
configatron.socialp.karma.comment      = +1
configatron.socialp.karma.vetting      = +1
configatron.socialp.karma.upvoted      = +2
configatron.socialp.karma.downvoted    = -10
configatron.socialp.karma.upvote       = +1
configatron.socialp.karma.downvote     = -1

configatron.socialp.karma.idea.created = +1
configatron.socialp.karma.idea.vetted  = +1
configatron.socialp.karma.idea.picked  = +10
configatron.socialp.karma.idea.live    = +20

configatron.socialp.vettings_needed    = 2

configatron.socialp.design_capacity    = 5
configatron.socialp.develop_capacity   = 5


if Rails.env.production?
  # production-specific settings
  configatron.omniauth.google_oauth2.app_id     = '829784005951-octuu39kre09vnkg44uen7jvr4o96rnd.apps.googleusercontent.com'
  configatron.omniauth.google_oauth2.app_secret = 'fW_q7ngOBH2ptMhpp4dvP-Rr'
else
  configatron.omniauth.google_oauth2.app_id     = '829784005951.apps.googleusercontent.com'
  configatron.omniauth.google_oauth2.app_secret = 'pxnPqfWV2m6DHg4XygEhOYlW'
end
