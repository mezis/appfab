module Traits::Idea::StarRating
  # 
  # impact_cache -- ratio of rating and sizing
  # star_cache -- which impact quintile the idea is from
  # 
  extend ActiveSupport::Concern

  included do
    before_validation :set_impact_cache, :if => :should_update_impact_cache?
    after_save :update_star_cache, :if => :impact_cache_changed?
  end

  def star_rating
    stars_cache
  end

  def impact_rating
    set_impact_cache if should_update_impact_cache?
    impact_cache || calculate_impact_rating
  end

  protected

  def set_impact_cache
    self.impact_cache = calculate_impact_rating
  end

  def calculate_impact_rating
    if rating && design_size && development_size
      1000 * rating / (design_size + development_size)
    else
      nil
    end
  end

  def should_update_impact_cache?
    rating_changed? || design_size_changed? || development_size_changed?
  end

  def update_star_cache
    self.class.update_star_cache account:account
  end

  module ClassMethods
    def update_star_cache(account:nil)
      raise ArgumentError unless account

      min_state = state_value(:vetted)
      max_state = state_value(:signed_off)
      idea_ids = account.ideas.
        where('state >= ? AND state <= ?', min_state, max_state).
        where('rating > ?', 0).
        by_impact.
        value_of(:id).
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
