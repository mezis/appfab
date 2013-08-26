class BookmarkCleanupService
  def run
    Idea.with_state(:live)
    .where('updated_at < ?', §.live_ideas_ttl.ago).find_each do |idea|
      idea.bookmarks.destroy_all
    end
  end
end
