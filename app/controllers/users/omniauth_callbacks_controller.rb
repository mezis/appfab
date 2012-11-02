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
    @user = User.find_or_create_from_auth_hash!(_auth_hash)

    sign_in @user
    flash[:success] = _('Welcome, %{user}!') % { user: @user.first_name }
    redirect_to ideas_path
  end

  def _auth_hash
    request.env['omniauth.auth']
  end
end
