namespace :appfab do
  namespace :ideas do
    desc 'updates star ratings for all ideas'
    task :update_stars_cache => :environment do
      require "account"
      Account.find_each do |account|
        Idea.update_star_cache(account:account)
      end
    end

    desc 'updates counter caches'
    task :update_counts => :environment do
      Idea.find_each do |idea|
        idea.update_column :comments_count, idea.comments.count
        idea.update_column :votes_cache,    idea.votes.count
      end
    end
  end
end