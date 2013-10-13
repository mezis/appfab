# encoding: UTF-8
require 'configatron'

configatron.app_name                   = 'AppFab'

module Kernel
  def § 
    configatron.app_fab
  end
end

§.karma.initial      = +20
§.karma.vote         = -10
§.karma.comment      = +1
§.karma.vetting      = +1
§.karma.upvoted      = +2
§.karma.downvoted    = -10
§.karma.upvote       = +1
§.karma.downvote     = -1

§.karma.idea.author.created = +1
§.karma.idea.author.vetted  = +1
§.karma.idea.author.picked  = +10
§.karma.idea.author.live    = +20

§.karma.idea.commenter.vetted  = +0
§.karma.idea.commenter.picked  = +1
§.karma.idea.commenter.live    = +1

§.karma.idea.backer.vetted     = +0
§.karma.idea.backer.picked     = +1
§.karma.idea.backer.live       = +10

§.vettings_needed    = 2
§.votes_needed       = 2

§.design_capacity    = 5
§.develop_capacity   = 5

§.live_ideas_ttl     = 1.week


if Rails.env.production? || Rails.env.staging?
  configatron.omniauth.google_oauth2.app_id     = ENV['GOOGLE_OAUTH2_APP_ID']
  configatron.omniauth.google_oauth2.app_secret = ENV['GOOGLE_OAUTH2_APP_SECRET']
else
  configatron.omniauth.google_oauth2.app_id     = '829784005951.apps.googleusercontent.com'
  configatron.omniauth.google_oauth2.app_secret = 'pxnPqfWV2m6DHg4XygEhOYlW'
end
