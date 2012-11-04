# encoding: UTF-8
class Rating::VoteObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    record.subject.increment! :rating, (record.user.voting_power * (record.up? ? +1 : -1))
  end

  def after_destroy(record)
    record.subject.increment! :rating, (record.user.voting_power * (record.up? ? -1 : +1))
  end
end
