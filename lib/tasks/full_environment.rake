desc "Eager loads the entire Rails environment"
# see http://stackoverflow.com/questions/4300240/rails-3-rake-task-cant-find-model-in-production
task :full_environment => :environment do
  Rails.application.eager_load!
end