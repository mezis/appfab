class Notification < ActiveRecord::Base
  attr_accessible :user_id, :subject, :body, :unread

  belongs_to :user
  belongs_to :subject, :polymorphic => true

  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :user
  
  default_values unread: true
end
