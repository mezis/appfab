# encoding: UTF-8
class Karma::IdeaObserver < ActiveRecord::Observer
  observe :idea

  def after_create(record)
    record.author.change_karma! by:configatron.socialp.karma.idea.created
  end
end
