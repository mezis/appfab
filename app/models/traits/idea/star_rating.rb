module Traits::Idea::StarRating
  # 
  # impact_cache -- ratio of rating and sizing
  # star_cache -- which impact quintile the idea is from
  # 
  extend ActiveSupport::Concern

  included do
    before_validation :set_impact_cache,  :if => :should_update_impact_cache?
    after_save        :update_star_cache, :if => :should_update_impact_cache?
  end

  def star_rating
    stars_cache
  end

  def impact_rating
    set_impact_cache if should_update_impact_cache?
    impact_cache || calculate_impact_rating
  end

  protected
  STARS_MIN_STATE = :voted
  STARS_MAX_STATE = :signed_off
  STARS_STATE_RANGE = (IdeaStateMachine.state_value(STARS_MIN_STATE)..IdeaStateMachine.state_value(STARS_MAX_STATE))

  def set_impact_cache
    self.impact_cache = calculate_impact_rating
  end

  def calculate_impact_rating
    return if rating.nil? || design_size.nil? || development_size.nil?
    return unless STARS_STATE_RANGE.include? state

    1000 * rating / (design_size + development_size)
  end

  def should_update_impact_cache?
    rating_changed? || design_size_changed? || development_size_changed? || state_changed?
  end

  def update_star_cache
    self.class.update_star_cache account:account
  end

  module ClassMethods
    def update_star_cache(account:nil)
      raise ArgumentError unless account

      min_state = IdeaStateMachine.state_value(STARS_MIN_STATE)
      max_state = IdeaStateMachine.state_value(STARS_MAX_STATE)
      idea_ids = account.ideas.
        where('state BETWEEN ? AND ?', min_state, max_state).
        where('rating > ?', 0).
        by_impact.
        pluck(:id).
        reverse

      group_size = (idea_ids.length / 5.0).ceil

      account.ideas.update_all(stars_cache:nil)
      return if group_size == 0

      idea_ids.in_groups_of(group_size, false).each_with_index do |group_ids, index|
        where(id:group_ids).update_all(stars_cache:index)
      end
    end
  end
end
