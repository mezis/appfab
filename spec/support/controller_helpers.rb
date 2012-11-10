# encoding: UTF-8
module ControllerHelpers
  def login_user(options = {})
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_user = User.make!(options)
      sign_in @current_user
    end
  end
end

