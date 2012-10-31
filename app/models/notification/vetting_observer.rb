class Notification::VettingObserver < ActiveRecord::Observer
  observe :vetting

  def after_create(vetting)
    return unless vetting.idea # happens in a few tests
    Notification::NewVetting.create!(recipient:vetting.idea.author, subject:vetting)
  end
end
