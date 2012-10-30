Given /I should see a (.*?) message/ do |kind|
  page.should have_selector("#flash_#{kind}")
end
