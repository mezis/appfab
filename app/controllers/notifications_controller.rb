# encoding: UTF-8
class NotificationsController < ApplicationController
  include Traits::RequiresLogin

  VALID_ANGLES = %w(unread all)
  DEFAULT_ANGLE = VALID_ANGLES.first
  PER_PAGE = 25

  def index
    @angle = session[:notifications_angle] = get_angle_from_params
    angle_scope = case @angle
      when 'all'    then :scoped
      when 'unread' then :unread
    end
    @notifications = current_user.notifications.
      send(angle_scope).
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
      next if notification.update_attributes(params[:notification])
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
end
