namespace :appfab do
  namespace :emails do
    task :send_notifications_digest => :environment do
      User.with_state(:visible).find_each do |user|
        require 'notification/mailer'
        next unless user.notifications.unread.count > 0

        notifications = user.notifications.unread.by_most_recent.limit(25)
        Notification::Mailer.digest(user, notifications).deliver
        notifications.read!
      end
    end
  end
end