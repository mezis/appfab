# encoding: UTF-8
module AccountsHelper

  def account_categories(user)
    user.andand.account.andand.categories.to_a || []
  end

  def account_category_title(category)
    case category
    when 'all'
      _('All categories')
    when 'none'
      _('No category')
    else
      category
    end
  end
end
