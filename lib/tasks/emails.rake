namespace :appfab do
  namespace :emails do
    task :send_notifications_digest => :environment do
      User.find_each do |user|
        next unless user.notifications.count > 1
        Notification::Mailer.digest(user).deliver
      end
    end
  end
end