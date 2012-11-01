# encoding: UTF-8
class Notification::VettingObserver < ActiveRecord::Observer
  observe :vetting

  def after_create(vetting)
    return unless vetting.idea # happens in a few tests
    vetting.idea.participants.each do |user|
      Notification::NewVetting.create! recipient:user, subject:vetting
    end
  end
end
