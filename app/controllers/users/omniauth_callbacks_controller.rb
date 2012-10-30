class Users::OmniauthCallbacksController < ApplicationController

  def developer
    _sign_in_from_hash
  end

  def google_oauth2
    _sign_in_from_hash
  end


  private

  def _sign_in_from_hash
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_or_create_from_auth_hash!(_auth_hash)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication # this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Developer") if is_navigational_format?
    else
      session['devise.data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def _auth_hash
    request.env['omniauth.auth']
  end
end
