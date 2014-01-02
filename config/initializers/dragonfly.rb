require 'dragonfly'
require 'dragonfly-activerecord/store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick,
    identify_command: 'identify -quiet'

  protect_from_dos_attacks true
  secret '07b23dcdfc0cc6f7ed12540ffdb1e74adc0fd914331c8936881edd9d4b5edd74'

  url_format '/media/:job/:name'

  datastore Dragonfly::ActiveRecord::Store.new
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
AppFab::Application.config.middleware.use Dragonfly::Middleware
