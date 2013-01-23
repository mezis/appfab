namespace :appfab do
  namespace :emails do
    task :send_notifications_digest => :environment do
      User.find_each do |user|
        next unless user.notifications.unread.count > 0

        notifications = user.notifications.unread.by_most_recent.limit(10)
        Notification::Mailer.digest(user, notifications).deliver
        notifications.read!
      end
    end
  end
end