# encoding: UTF-8
class Notification::IdeaObserver < ActiveRecord::Observer
  observe :idea

  def after_create(record)
    return unless record.account # happens in tests
    record.account.users.playing(:product_manager, :architect).each do |user|
      Notification::NewIdea.create! subject:record, recipient:user
    end
  ensure
    return true
  end


  def after_save(record)
    return unless record.state_changed?
    notification_class = StateChangeNotifications[record.state_name] or return
    record.participants.each do |user|
      notification_class.create! subject:record, recipient:user
    end
  ensure
    return true
  end

  private

  StateChangeNotifications = {
    :vetted => Notification::Idea::Vetted,
    :picked => Notification::Idea::Picked,
    :live   => Notification::Idea::Live
  }
end
