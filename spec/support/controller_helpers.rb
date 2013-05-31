# encoding: UTF-8
module ControllerHelpers
  def login_user(options = {})
    fixtures :users, :logins, :accounts

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:login]
      @current_user  = users(:abigale_balisteri)
      sign_in @current_user.login
    end
  end
end

