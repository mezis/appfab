# Enable use of poltergeist / phantomjs
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout:120)
end

Capybara.javascript_driver = :poltergeist

def wait_for_page_load
  page.has_content? '' if Capybara.javascript_driver == :webkit
end

