module Traits::RecentCreation
  extend ActiveSupport::Concern

  RECENT_CREATION_DELAY = 15.minutes

  included do
    scope :recently_created, lambda { where('created_at > ?', RECENT_CREATION_DELAY.ago) }
    scope :recently_updated, lambda { where('updated_at > ?', RECENT_CREATION_DELAY.ago) }
  end

  def recently_created?
    created_at > RECENT_CREATION_DELAY.ago
  end

  def recently_updated?
    updated_at > RECENT_CREATION_DELAY.ago
  end

end