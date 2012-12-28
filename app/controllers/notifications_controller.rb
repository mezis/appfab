# encoding: UTF-8
class NotificationsController < ApplicationController
  before_filter :authenticate_login!

  ValidAngles = %w(unread all)
  DefaultAngle = ValidAngles.first

  def index
    @angle = session[:notifications_angle] = get_angle_from_params
    @notifications = current_user.notifications.send(@angle.to_sym)
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    if @notification.update_attributes(params[:notification])
      redirect_to notifications_path, :notice  => _("Successfully updated notification.")
    else
      redirect_to notifications_path, :failure => _("Failed to update notification")
    end
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    redirect_to notifications_url, :notice => _("Successfully destroyed notification.")
  end

  private

  def get_angle_from_params
    return params[:angle] if ValidAngles.include?(params[:angle])
    session[:notifications_angle] || DefaultAngle
  end
end
