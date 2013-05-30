# Enable use of poltergeist / phantomjs
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

def wait_for_page_load
  page.has_content? '' if Capybara.javascript_driver == :webkit
end

