# encoding: UTF-8

Given /I should see an? (.*?) message/ do |kind|
  page.should have_selector(".flash.alert-#{kind}")
end
