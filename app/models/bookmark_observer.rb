# Automatically bookmark idea when a user participates
class BookmarkObserver < ActiveRecord::Observer
  observe :idea, :vote, :vetting, :comment

  def after_save(record)
    idea = case record
      when Idea                   then record
      when Vetting, Vote, Comment then record.idea
    end
    user = case record
      when Idea, Comment then record.author
      when Vetting, Vote then record.user
    end

    user.bookmarks.transaction do
      return if user.bookmarks.idea_is(idea).any?
      user.bookmarks.create!(idea: idea)
    end
  end
end
