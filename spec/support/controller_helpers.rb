# encoding: UTF-8
module ControllerHelpers
  def login_user(options = {})
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:login]
      @current_user  = User.make!(options)
      sign_in @current_user.login
    end
  end
end

