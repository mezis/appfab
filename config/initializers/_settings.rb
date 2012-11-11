# encoding: UTF-8
require 'configatron'

configatron.app_name                   = 'AppFab'

configatron.app_fab.karma.initial      = +20
configatron.app_fab.karma.vote         = -10
configatron.app_fab.karma.comment      = +1
configatron.app_fab.karma.vetting      = +1
configatron.app_fab.karma.upvoted      = +2
configatron.app_fab.karma.downvoted    = -10
configatron.app_fab.karma.upvote       = +1
configatron.app_fab.karma.downvote     = -1

configatron.app_fab.karma.idea.author.created = +1
configatron.app_fab.karma.idea.author.vetted  = +1
configatron.app_fab.karma.idea.author.picked  = +10
configatron.app_fab.karma.idea.author.live    = +20

configatron.app_fab.karma.idea.commenter.vetted  = +0
configatron.app_fab.karma.idea.commenter.picked  = +1
configatron.app_fab.karma.idea.commenter.live    = +1

configatron.app_fab.karma.idea.backer.picked     = +1
configatron.app_fab.karma.idea.backer.live       = +1

configatron.app_fab.vettings_needed    = 2
configatron.app_fab.votes_needed       = 1

configatron.app_fab.design_capacity    = 5
configatron.app_fab.develop_capacity   = 5


if Rails.env.production?
  configatron.omniauth.google_oauth2.app_id     = ENV['GOOGLE_OAUTH2_APP_ID']
  configatron.omniauth.google_oauth2.app_secret = ENV['GOOGLE_OAUTH2_APP_SECRET']
else
  configatron.omniauth.google_oauth2.app_id     = '829784005951.apps.googleusercontent.com'
  configatron.omniauth.google_oauth2.app_secret = 'pxnPqfWV2m6DHg4XygEhOYlW'
end
