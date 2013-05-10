# encoding: UTF-8
class Rating::VoteObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    update_rating record, 1
  end

  def after_destroy(record)
    update_rating record, -1
  end

  private

  def update_rating(record, factor)
    record.subject.rating += (record.user.voting_power * (record.up? ? factor : -factor))
    record.subject.save!
  end
end
