# encoding: UTF-8
class Users::OmniauthCallbacksController < ApplicationController

  def developer
    _sign_in_from_hash
  end

  def google_oauth2
    _sign_in_from_hash
  end


  def failure
    flash[:failure] = _('Sorry, something went wrong while logging you in.')
    redirect_to root_path
  end


  private

  def _sign_in_from_hash
    Rails.logger.info _auth_hash
    login = Login.find_or_create_from_auth_hash!(_auth_hash)
    return_to = session[:return_to]

    sign_in login
    flash[:success] = _('Welcome, %{user}!') % { user: login.first_name }
    redirect_to return_to || ideas_path(angle: IdeasController::DefaultAngle)
  end

  def _auth_hash
    request.env['omniauth.auth']
  end
end
