namespace :appfab do
  namespace :users do
    desc 'Saves last-seen timestamps from cache to DB'
    task :update_last_seen_at => :full_environment do
      User.find_each { |user| user.update_last_seen_at! }
    end
  end
end