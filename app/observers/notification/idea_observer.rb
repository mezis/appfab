# encoding: UTF-8
class Notification::IdeaObserver < ActiveRecord::Observer
  observe :idea

  def after_create(record)
    return true unless record.state_machine.submitted? 
    record.account.users.playing(:product_manager, :architect).each do |user|
      Notification::NewIdea.create! subject:record, recipient:user
    end
    true
  end


  def after_save(record)
    return true unless record.state_changed?
    return true if record.state_was && (record.state_was >= record.state)
    notification_class = StateChangeNotifications[record.state_machine.state_name] or return
    record.participants.each do |user|
      notification_class.create! subject:record, recipient:user
    end
    true
  end

  private

  StateChangeNotifications = {
    :submitted => Notification::NewIdea,
    :vetted    => Notification::Idea::Vetted,
    :picked    => Notification::Idea::Picked,
    :live      => Notification::Idea::Live
  }
end
