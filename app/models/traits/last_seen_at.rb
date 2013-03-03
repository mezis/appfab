module Traits::LastSeenAt
  def last_seen_at
    Rails.cache.read(last_seen_at_cache_key) || super || login.last_sign_in_at
  end

  def last_seen_at=(value)
    Rails.cache.write(last_seen_at_cache_key, value)
    super(value)
  end

  def update_last_seen_at!
    timestamp = Rails.cache.read(last_seen_at_cache_key) or return
    update_column :last_seen_at, timestamp
  end

  private 

  def last_seen_at_cache_key
    "#{self.class.name}/last_seen_at/#{id}"
  end
end