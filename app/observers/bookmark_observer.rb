# Automatically bookmark idea when a user participates
class BookmarkObserver < ActiveRecord::Observer
  observe :idea, :comment

  def after_save(record)
    idea = case record
      when Idea     then record
      when Comment  then record.idea
    end

    user = record.author

    user.bookmarks.transaction do
      return if user.bookmarks.idea_is(idea).any?
      user.bookmarks.create!(idea: idea)
    end
  end
end
