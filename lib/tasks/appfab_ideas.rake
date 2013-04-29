namespace :appfab do
  namespace :ideas do
    task :update_stars_cache => :environment do
      Account.find_each do |account|
        Idea.update_star_cache(account:account)
      end
    end
  end
end