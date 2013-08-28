class Pusher::UserObserver < ActiveRecord::Observer
  observe :user

  def after_save(user)
    return unless user.karma_changed?
    Pusher.trigger("user-#{user.id}", 'update-user', karma:user.karma)
    true
  end

end
