class Notification::VettingObserver < ActiveRecord::Observer
  observe :vetting

  def after_create(vetting)
    return unless vetting.idea # happens in a few tests
    vetting.idea.author.notifications.create! subject:vetting,
      body:_('@%{user} has just vetted your idea #%{story_id}!') % {
        user: vetting.user.first_name, idea: vetting.idea.id
      }
  end
end
