class Notification < ActiveRecord::Base
  attr_accessible :user_id, :subject, :body, :unread

  belongs_to :user
  belongs_to :subject, :polymorphic => true

  
  default_values unread: true
end
