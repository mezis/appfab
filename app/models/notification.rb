class Notification < ActiveRecord::Base
  attr_accessible :user_id, :subject_type, :subject_id, :body, :unread
end
