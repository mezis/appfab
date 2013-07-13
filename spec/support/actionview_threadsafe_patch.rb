# FIXME: this will no longer be necessary once we're on Rails 4
# 
# This is a provisional fix for an rspec-rails issue
# (see https://github.com/rspec/rspec-rails/issues/476).
# It allows for a proper test execution with `config.threadsafe!`.

HELPER_DIR = Rails.root.join('app/helpers')

ActionView::TestCase::TestController.instance_eval do
  helper Rails.application.routes.url_helpers
  Pathname.glob(HELPER_DIR.join('**/*_helper.rb')).each do |pathname|
    helper_name = pathname.relative_path_from(HELPER_DIR).
      to_s.chomp('_helper.rb')
    helper helper_name
  end
end
ActionView::TestCase::TestController.class_eval do
  def _routes
    Rails.application.routes
  end
end
