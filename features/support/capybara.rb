# Enable use of capybara-webkit
require 'capybara-webkit'
Capybara.javascript_driver = :webkit

def wait_for_page_load
  page.has_content? '' if Capybara.javascript_driver == :webkit
end