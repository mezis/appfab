# encoding: UTF-8
class Notification::CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(record)
    return unless record.idea # happens in tests
    record.idea.participants.each do |user|
      next if user == record.author # don't get notified for my own comments
      Notification::NewComment.create! subject:record, recipient:user
    end
  ensure
    return true
  end
end
