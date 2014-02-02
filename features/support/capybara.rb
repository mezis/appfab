# Enable use of poltergeist / phantomjs
require 'capybara/poltergeist'

module Capybara::Poltergeist
  class Client
    private
    def redirect_stdout(to)
      prev = STDOUT.dup
      prev.autoclose = false
      $stdout = to
      STDOUT.reopen(to)
 
      prev = STDERR.dup
      prev.autoclose = false
      $stderr = to
      STDERR.reopen(to)
      yield
    ensure
      STDOUT.reopen(prev)
      $stdout = STDOUT
      STDERR.reopen(prev)
      $stderr = STDERR
    end
  end
end

class WarningSuppressor
  IGNORES = [
    /QFont::setPixelSize: Pixel size <= 0/,
    /CoreText performance note:/,
    /Method userSpaceScaleFactor in class NSView is deprecated/
  ]

  class << self
    def write(message)
      return 0 if suppress?(message)
      puts(message)
      return 1
    end

    private

    def suppress?(message)
      IGNORES.any? { |re| message =~ re }
    end
  end
end
 

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout:120, phantomjs_logger: WarningSuppressor)
end

Capybara.javascript_driver = :poltergeist

def wait_for_page_load
  page.has_content? '' if Capybara.javascript_driver == :webkit
end

Capybara.default_host = "http://#{ENV['APP_DOMAIN']}"
