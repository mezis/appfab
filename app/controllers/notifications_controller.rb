# encoding: UTF-8
class NotificationsController < ApplicationController
  include Traits::RequiresLogin

  VALID_ANGLES = %w(unread all)
  DEFAULT_ANGLE = VALID_ANGLES.first
  PER_PAGE = 25

  def index
    @angle = session[:notifications_angle] = get_angle_from_params
    @notifications = current_user.notifications
    @notifications = @notifications.unread if @angle == 'unread'
    @notifications = @notifications.
      by_most_recent.
      paginate(per_page: PER_PAGE, page: params[:page])
  end

  def update
    notifications = if params[:id] == 'all'
      current_user.notifications
    else
      current_user.notifications.where(id: params[:id].to_i)
    end

    notifications.find_each do |notification|
      @notification = notification # keep the last one, the view will need it
      next if notification.update_attributes(notification_params)
      flash[:error] = _("Failed to update notification.")
      break
    end
    flash[:success] = _("Successfully updated notification.") unless flash[:error]

    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.js
    end
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    flash[:notice] = _("Successfully removed notification.")
    redirect_to notifications_url
  end

  private

  def get_angle_from_params
    return params[:angle] if VALID_ANGLES.include?(params[:angle])
    session[:notifications_angle] || DEFAULT_ANGLE
  end

  def notification_params
    params.require(:notification).permit(:unread)
  end
end

