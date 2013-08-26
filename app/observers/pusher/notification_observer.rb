class Pusher::NotificationObserver < ActiveRecord::Observer
  observe 'Notification::Base'

  def after_create(notification)
    user = notification.recipient
    Pusher.trigger("user-#{user.id}", 'update-user', notifications:user.notifications.unread.count)
    true
  end

end
