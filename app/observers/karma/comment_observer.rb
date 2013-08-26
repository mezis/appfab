# encoding: UTF-8
class Karma::CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(record)
    record.author.change_karma! by:§.karma.comment
  ensure
    return true
  end

  def after_destroy(record)
    record.author.change_karma! by: -§.karma.comment
  ensure
    return true
  end
end
