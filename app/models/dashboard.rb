# A Facade to ideas, comments, and notifications for a given user.
class Dashboard

  def initialize(user:nil)
    raise ArgumentError, 'user required' if !user.kind_of?(User)

    @user    = user
    @account = user.account
  end

  def block_size
    5
  end

  def ideas_to_size
    return [] unless @user.plays?(:product_manager, :architect)

    conditions = {
      :product_manager => :design_size,
      :architect => :development_size
    }.map { |role,field|
      @user.plays?(role) ? "#{field} IS NULL" : nil
    }.compact.join(' OR ')
    random_visible_ideas.with_state(:submitted).where(conditions)
  end

  def ideas_to_vet
    random_visible_ideas.with_state(:submitted).where('design_size IS NOT NULL AND development_size IS NOT NULL')
  end

  def ideas_recently_active
    visible_ideas.by_activity.limit(block_size)
  end

  def ideas_to_vote
    random_visible_ideas.with_state(:vetted, :voted).not_backed_by(@user)
  end

  def ideas_recently_submitted
    visible_ideas.with_state(:submitted).by_creation.limit(block_size)
  end

  def ideas_working_set
    visible_ideas.
      with_state(:picked, :designed, :approved, :implemented, :signed_off).
      where('product_manager_id = ?', @user.id).
      by_activity
  end

  def ideas_for_dictator
    visible_ideas.with_state(:designed, :implemented).by_activity.limit(block_size)
  end

  def notifications_recent
    @user.notifications.unread.by_most_recent.limit(block_size)
  end

  def comments_on_followed_ideas
    follow_idea_ids = @user.bookmarked_ideas.pluck(:id)
    return [] if follow_idea_ids.empty?
    Comment.by_created_at.where(idea_id:follow_idea_ids).limit(block_size)
  end


  private

  def visible_ideas
    @account.ideas.without_state(:draft).includes(:participants => :login)
  end

  def random_visible_ideas
    visible_ideas.take_random(count:block_size, seed:random_seed)
  end

  # return the same seed for a given user and day
  def random_seed
    Date.today.strftime('%Y%m%d').to_i * @user.id
  end

end
