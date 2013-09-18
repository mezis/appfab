class User::InvitationMailer < ApplicationMailer
  layout 'email'

  def invitation(inviter:nil, user:nil)
    @user = user
    headers['X-MC-Tags'] = 'appfab,user-invitation'
    mail to: user.login.email,
      subject: _("%{inviter} has invited you to join team %{name} on %{appname}") % {
        inviter:  inviter.first_name,
        name:     user.account.name,
        appname:  configatron.app_name
      }
  end
end
