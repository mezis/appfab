# encoding: UTF-8
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


UserRole.blueprint do
  name       { 'product_manager' }
  user       { User.last || User.make! }
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

Idea.blueprint(:submitted) do
end

Idea.blueprint(:sized) do
  development_size { 1 }
  design_size      { 2 }
end

Idea.blueprint(:managed) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
end

Idea.blueprint(:vetted) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { Idea.state_machine.state(:vetted).value }
end


Idea.blueprint(:voted) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { Idea.state_machine.state(:voted).value }
end


Idea.blueprint(:designed) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { Idea.state_machine.state(:designed).value }
end


Idea.blueprint(:signed_off) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { Idea.state_machine.state(:signed_off).value }
end


Notification::Base.blueprint do
  recipient  { User.last || User.make! }
  subject    { Idea.last || Idea.make! }
end


Vote.blueprint do
  user       { User.last || User.make! }
  subject    { Idea.last || Idea.make! }
  up         { true }
end


Vetting.blueprint do
  user       { User.last || User.make! }
  idea       { Idea.last || Idea.make! }
end


Attachment.blueprint do
  owner      { User.last || User.make! }
  uploader   { User.last || User.make! }
  # a very small valid PNG (http://garethrees.org/2007/11/14/pngcrush/)
  file       { Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==') }
end

User::Bookmark.blueprint do
  user       { User.last || User.make! }
  idea       { Idea.last || Idea.make! }
end
