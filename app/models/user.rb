class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email_address, :role, :karma, :account_id

  belongs_to :account
  has_many :ideas
  has_many :votes
  has_many :comments, :as => :author
  has_many :notifications
end
