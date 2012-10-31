class Notification::UserObserver < ActiveRecord::Observer
  observe :user

  def after_save(user)
    return unless user.account && user.account_id_changed?
    user.account.users.each do |user|
      user.notifications.create! subject:user,
        body:_('User %{user} has just joined your account!') % { user:user.first_name }
    end
  end

end
