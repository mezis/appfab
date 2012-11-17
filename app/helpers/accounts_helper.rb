# encoding: UTF-8
module AccountsHelper

  def account_categories(user)
    user.andand.account.andand.categories || []
  end
end
