unless ENV['RAVEN_URL'].blank? #RAVEN_URLS[Rails.env]
  require 'raven'

  Raven.configure do |config|
    config.dsn                 = ENV['RAVEN_URL']
    config.environments        = [Rails.env]

    # default list of ignored exceptions is too drastic:
    #   ActiveRecord::RecordNotFound
    #   ActionController::RoutingError
    #   ActionController::InvalidAuthenticityToken
    #   CGI::Session::CookieStore::TamperedWithCookie
    #   ActionController::UnknownAction
    #   AbstractController::ActionNotFound
    #   Mongoid::Errors::DocumentNotFound
    excluded_exceptions = ENV['RAVEN_IGNORE_EXCEPTIONS']
    config.excluded_exceptions = excluded_exceptions.split unless excluded_exceptions.blank?
  end
end
