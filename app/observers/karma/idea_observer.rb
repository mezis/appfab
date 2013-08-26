# encoding: UTF-8
class Karma::IdeaObserver < ActiveRecord::Observer
  observe :idea

  def after_create(record)
    record.author.change_karma! by:§.karma.idea.author.created
  ensure
    return true
  end

  def after_destroy(record)
    record.author.change_karma! by:-§.karma.idea.author.created
  ensure
    return true
  end

  def after_save(record)
    return unless record.state_changed?
    return unless [:vetted, :picked, :live].include? record.state_name
    record.author.change_karma! by:§.karma.idea.author.send(record.state_name)

    record.commenters.each do |commenter|
      commenter.change_karma! by:§.karma.idea.commenter.send(record.state_name)
    end

    record.backers.each do |commenter|
      commenter.change_karma! by:§.karma.idea.backer.send(record.state_name)
    end
  ensure
    return true
  end
end
