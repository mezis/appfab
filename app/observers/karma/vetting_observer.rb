# encoding: UTF-8
class Karma::VettingObserver < ActiveRecord::Observer
  observe :vetting

  def after_create(record)
    record.user.change_karma! by: configatron.app_fab.karma.vetting
  ensure
    return true
  end

  def after_destroy(record)
    record.user.change_karma! by: -configatron.app_fab.karma.vetting
  ensure
    return true
  end
end
