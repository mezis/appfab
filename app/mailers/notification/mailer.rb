class Notification::Mailer < ActionMailer::Base
  default from: '"AppFab" <noreply@dec0de.me>'
  layout 'email'
  helper :users, :user_roles, :application

  # all paths need to be turned into URLs of course inside an email.
  # neat trick:
  helper do
    def polymorphic_path(*args)
      polymorphic_url(*args)
    end
  end

  def digest(user)
    @user = user
    headers['X-MC-Tags'] = 'appfab,notification-digest'
    mail to: user.login.email,
      subject: _('Notifications for team %{name} at %{appname}') % {
        name:     user.account.name,
        appname:  configatron.app_name
      }
  end
end
