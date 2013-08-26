# encoding: UTF-8
class Karma::VoteOnIdeaObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    return unless record.subject_type == 'Idea'
    change_karma(record, +1)
  ensure
    return true
  end

  def after_destroy(record)
    return unless record.subject_type == 'Idea'
    change_karma(record, -1)
  ensure
    return true
  end

  private

  def change_karma(record, sign)
    return if record.down? # no downvoting on ideas (normally)
    record.user.change_karma!           by:(sign * §.karma.vote)
    record.subject.author.change_karma! by:(sign * §.karma.upvoted)
  end
end
