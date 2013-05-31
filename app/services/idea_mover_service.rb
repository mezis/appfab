class IdeaMoverService
  def initialize(idea:nil, account:nil)
    raise ArgumentError, 'must pass an Idea' unless idea.kind_of?(Idea)
    raise ArgumentError, 'must pass an Account' unless account.kind_of?(Account)
    raise ArgumentError, 'idea is already in that account' if idea.account == account

    @idea    = idea
    @account = account
  end

  def run
    @idea.transaction do
      @idea.account  = @account
      @idea.category = nil
      update_users [@idea], :author, :product_manager
      update_users @idea.votes,    :user
      update_users @idea.vettings, :user
      update_users @idea.comments, :author
    end
  end

  private

  # update the user fields of +records+ to be memebrs of the new +@account+
  def update_users(records, *fields)
    iterate_through(records) do |record|
      fields.each do |field|
        old_user = record.send(field) or next
        new_user = user_in_account(old_user)
        record.send(:"#{field}=", new_user)
      end
      record.save!
    end
  end

  # returns +user+'s identity in +account+, possibly
  # creating it on the fly as a hidden user
  def user_in_account(user)
    login = user.login
    other_user = @account.users.find_by_login_id(login.id)
    return other_user unless other_user.nil?
    @account.users.create!(login:login, state:User.state_value(:hidden))
  end

  # conveninence iterator using find_each or each as available
  def iterate_through(array_or_scope)
    method =  array_or_scope.respond_to?(:find_each) ? :find_each : :each
    array_or_scope.send(method) { |x| yield x }
  end
end
