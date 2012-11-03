# encoding: UTF-8
class Karma::VoteOnCommentObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    return unless record.subject_type == 'Comment'
    if record.up?
      record.user.change_karma!           by:configatron.app_fab.karma.upvote
      record.subject.author.change_karma! by:configatron.app_fab.karma.upvoted
    else
      record.user.change_karma!           by:configatron.app_fab.karma.downvote
      record.subject.author.change_karma! by:configatron.app_fab.karma.downvoted
    end
  end
end
