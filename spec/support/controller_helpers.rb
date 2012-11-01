# encoding: UTF-8
module ControllerHelpers
  def login_user(options = {})
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in User.make!(options)
    end
  end
end

