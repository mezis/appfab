namespace :appfab do
  namespace :ideas do
    desc 'updates star ratings for all ideas'
    task :update_stars_cache => :full_environment do
      Account.find_each do |account|
        Idea.update_star_cache(account:account)
      end
    end

    desc 'updates counter caches'
    task :update_counts => :full_environment do
      Idea.find_each do |idea|
        idea.update_column :comments_count, idea.comments.count
        idea.update_column :votes_cache,    idea.votes.count
      end
    end

    desc 'removes bookmarks for old live ideas'
    task :bookmark_cleanup => :full_environment do
      BookmarkCleanupService.new.run
    end
  end
end
