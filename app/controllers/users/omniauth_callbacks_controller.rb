class Users::OmniauthCallbacksController < ApplicationController
  def developer
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_or_create_from_auth_hash!(auth_hash)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication # this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Developer") if is_navigational_format?
    else
      session["devise.developer_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
