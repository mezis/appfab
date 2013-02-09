# encoding: UTF-8
module ViewHelpers
  def login_user(symbol = nil)
    before(:each) do
      current_user = symbol ? send(symbol) : User.make!
      [controller, view].each do |resource|
        resource.stub :current_user    => current_user
        resource.stub :current_account => current_user.account
        resource.stub :current_login   => current_user.login
      end
    end
  end
end

