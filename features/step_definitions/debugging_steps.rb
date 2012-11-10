require 'pry'
require 'pry-nav'

And /^show me the page$/ do
  save_and_open_page
end

And /^debugger$/ do
  binding.pry
end