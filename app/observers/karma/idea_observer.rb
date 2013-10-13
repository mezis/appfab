# encoding: UTF-8
class Karma::IdeaObserver < ActiveRecord::Observer
  observe :idea

  def after_create(record)
    record.author.change_karma! by:§.karma.idea.author.created
    true
  end

  def after_destroy(record)
    record.author.change_karma! by:-§.karma.idea.author.created
    true
  end

  def after_save(record)
    state_name = record.state_machine.state_name
    return true unless record.state_changed?
    return true unless [:vetted, :picked, :live].include?(state_name)
    record.author.change_karma! by:§.karma.idea.author.send(state_name)

    record.commenters.each do |commenter|
      commenter.change_karma! by:§.karma.idea.commenter.send(state_name)
    end

    record.backers.each do |commenter|
      commenter.change_karma! by:§.karma.idea.backer.send(state_name)
    end
    true
  end
end
