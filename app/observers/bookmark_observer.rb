# Automatically bookmark idea when a user participates
class BookmarkObserver < ActiveRecord::Observer
  observe :idea, :comment

  def after_create(record)
    return true unless record.kind_of?(Idea)
    _create_bookmark_for(record, record.author)
  end

  def after_save(record)
    return true unless record.kind_of?(Comment)
    _create_bookmark_for(record.idea, record.author)
  end

  private

  def _create_bookmark_for(idea, user)
    user.bookmarks.transaction do
      return if user.bookmarks.idea_is(idea).any? || user.plays?(:product_manager)
      user.bookmarks.create!(idea: idea)
    end
  end
end
