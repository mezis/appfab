class Admin::EmailPreviewsController < ApplicationController
  before_filter :authenticate_login!

  def index
    @user = User.first
    @notifications = @user.notifications.last(100).shuffle.take(10)
    html = Notification::Mailer.digest(@user, @notifications).body
    render text:html, content_type:'text/html'
  end
end
