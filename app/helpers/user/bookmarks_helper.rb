module User::BookmarksHelper
  def bookmark_for_idea(idea)
    current_user.bookmarks.idea_is(idea).first
  end
end
