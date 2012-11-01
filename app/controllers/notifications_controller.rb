# encoding: UTF-8
class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @notifications = Notification::Base.all
  end

  def show
    @notification = Notification::Base.find(params[:id])
  end

  def update
    @notification = Notification::Base.find(params[:id])
    if @notification.update_attributes(params[:notification])
      redirect_to root_path, :notice  => _("Successfully updated notification.")
    else
      redirect_to root_path, :failure => _("Failed to update notification")
    end
  end

  def destroy
    @notification = Notification::Base.find(params[:id])
    @notification.destroy
    redirect_to notifications_url, :notice => _("Successfully destroyed notification.")
  end
end
