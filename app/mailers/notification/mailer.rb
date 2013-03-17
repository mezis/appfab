class Notification::Mailer < ApplicationMailer
  layout 'email'

  def digest(user, notifications)
    @user = user
    @notifications = notifications
    headers['X-MC-Tags'] = 'appfab,notification-digest'
    mail to: user.login.email,
      subject: _('Notifications for team %{name} at %{appname}') % {
        name:     user.account.name,
        appname:  configatron.app_name
      }
  end
end
