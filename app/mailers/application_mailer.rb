class ApplicationMailer < ActionMailer::Base
  default from: '"AppFab" <noreply@dec0de.me>'
  helper :users, :user_roles, :application

  # all paths need to be turned into URLs of course inside an email.
  # neat trick:
  helper do
    def polymorphic_path(*args)
      polymorphic_url(*args)
    end
  end
end
