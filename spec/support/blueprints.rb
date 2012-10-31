require 'machinist/active_record'
require 'faker'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Account.blueprint do
  name       { Faker::Company.name }
  domain     { Faker::Internet.domain_name }
end


User.blueprint do
  first_name { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  email      { Faker::Internet.email }
  password   { 'test-password' }
  account    { Account.last || Account.make! }
end


Comment.blueprint do
  author     { User.last || User.make! }
  idea       { Idea.last || Idea.make! }
  body       { Faker::Lorem.paragraph }
end


Idea.blueprint do
  author     { User.last || User.make! }
  title      { Faker::Lorem.sentence }
  problem    { Faker::Lorem.paragraph }
  solution   { Faker::Lorem.paragraph }
  metrics    { Faker::Lorem.paragraph }
  deadline   { Date.today + 90 }
end


Notification.blueprint do
  user       { User.last || User.make! }
  subject    { Idea.last || Idea.make! }
  body       { Faker::Lorem.sentence }
end


Vote.blueprint do
  user       { User.last || User.make! }
  idea       { Idea.last || Idea.make! }
end


Vetting.blueprint do
  user       { User.last || User.make! }
  idea       { Idea.last || Idea.make! }
end