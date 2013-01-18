# encoding: UTF-8
class Notification::VettingObserver < ActiveRecord::Observer
  observe :vetting

  def after_create(vetting)
    return unless vetting.idea # happens in a few tests
    vetting.idea.participants.each do |user|
      next if user == vetting.user # don't get notified for my own vettings
      Notification::NewVetting.create! recipient:user, subject:vetting
    end
  ensure
    return true
  end
end
