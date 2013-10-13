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

Login.blueprint do
  first_name { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  email      { Faker::Internet.email }
  password   { 'test-password' }
end

User.blueprint do
  login
  account    { Account.last || Account.make! }
end


User::Role.blueprint do
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
  account    { Account.last || Account.make! }
  title      { Faker::Lorem.sentence }
  problem    { Faker::Lorem.paragraph }
  solution   { Faker::Lorem.paragraph }
  metrics    { Faker::Lorem.paragraph }
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
  state            { IdeaStateMachine.state_value(:vetted) }
end

Idea.blueprint(:voted) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { IdeaStateMachine.state_value(:voted) }
end

Idea.blueprint(:designed) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { IdeaStateMachine.state_value(:designed) }
end

Idea.blueprint(:implemented) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { IdeaStateMachine.state_value(:implemented) }
end

Idea.blueprint(:signed_off) do
  development_size { 1 }
  design_size      { 2 }
  product_manager  { User.make!.plays!(:product_manager) }
  state            { IdeaStateMachine.state_value(:signed_off) }
end


Notification::Base.blueprint do
  recipient  { User.last || User.make! }
  subject    { Idea.last || Idea.make! }
end

Notification::NewIdea.blueprint do
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

Message::Marketing.blueprint do
  summary    { { 'en' => Faker::Lorem.sentence } }
end
