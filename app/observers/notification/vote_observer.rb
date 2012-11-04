# encoding: UTF-8
class Notification::VoteObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    return unless record.subject # happens in a few tests
    case record.subject
    when Comment
      Notification::NewVoteOnComment.create! recipient:record.subject.author, subject:record
    when Idea
      record.subject.participants.each do |user|
        Notification::NewVoteOnIdea.create! recipient:user, subject:record
      end
    end
  ensure
    return true
  end
end
