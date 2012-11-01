class Karma::CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(record)
    record.author.change_karma! by:configatron.socialp.karma.comment
  end
end
