# encoding: UTF-8
class Karma::VoteOnCommentObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    return unless record.subject_type == 'Comment'
    change_karma(record, +1)
  ensure
    return true
  end

  def after_destroy(record)
    return unless record.subject_type == 'Comment'
    change_karma(record, -1)
  ensure
    return true
  end

  private

  def change_karma(record, sign)
    if record.up?
      record.user.change_karma!           by:(sign * §.karma.upvote)
      record.subject.author.change_karma! by:(sign * §.karma.upvoted)
    else
      record.user.change_karma!           by:(sign * §.karma.downvote)
      record.subject.author.change_karma! by:(sign * §.karma.downvoted)
    end
  end    
end
