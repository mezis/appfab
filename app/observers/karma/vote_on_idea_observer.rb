class Karma::VoteOnIdeaObserver < ActiveRecord::Observer
  observe :vote

  def after_create(record)
    return unless record.subject_type == 'Idea'
    return if record.down? # no downvoting on ideas (normally)
    
    record.user.change_karma!           by:configatron.socialp.karma.vote
    record.subject.author.change_karma! by:configatron.socialp.karma.upvoted
  end
end
