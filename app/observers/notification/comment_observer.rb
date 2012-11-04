# encoding: UTF-8
class Notification::CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(record)
    return unless record.idea # happens in tests
    record.idea.participants.each do |user|
      Notification::NewComment.create! subject:record, recipient:user
    end
  ensure
    return true
  end
end
