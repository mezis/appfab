# encoding: utf-8

namespace :users do

  desc 'Saves last-seen timestamps from cache to DB'
  task :update_last_seen_at => :environment do
    User.find_each do |user|
      user.update_last_seen_at!
    end
  end
end
