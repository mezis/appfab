# encoding: UTF-8
class Karma::VoteOnCommentObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    return unless record.subject_type == 'Comment'
    if record.up?
      record.user.change_karma!           by:configatron.socialp.karma.upvote
      record.subject.author.change_karma! by:configatron.socialp.karma.upvoted
    else
      record.user.change_karma!           by:configatron.socialp.karma.downvote
      record.subject.author.change_karma! by:configatron.socialp.karma.downvoted
    end
  end
end
