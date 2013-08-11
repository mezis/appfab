module User::BookmarksHelper
  def bookmark_for_idea(idea)
    @current_user_bookmarks ||= {}
    @current_user_bookmarks[current_user.id] ||= begin
      current_user.bookmarks.group_by(&:idea_id)
    end
    @current_user_bookmarks[current_user.id][idea.id].andand.first
  end
end
