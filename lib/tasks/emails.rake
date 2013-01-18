namespace :appfab do
  namespace :emails do
    task :send_notifications_digest => :environment do
      User.find_each do |user|
        Notification::Mailer.digest(user).deliver
        next unless user.notifications.unread.count > 0
      end
    end
  end
end