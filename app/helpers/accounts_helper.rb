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

  def account_category_class(account, category)
    categories = account.categories.sort
    index = categories.index(category) or return 'af-category-none'
    "af-category-%d-of-%d" % [index + 1, categories.size]
  end
end
