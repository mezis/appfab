class NotificationsController < ApplicationController
  def index
    @notifications = Notification.all
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(params[:notification])
    if @notification.save
      redirect_to @notification, :notice => "Successfully created notification."
    else
      render :action => 'new'
    end
  end

  def edit
    @notification = Notification.find(params[:id])
  end

  def update
    @notification = Notification.find(params[:id])
    if @notification.update_attributes(params[:notification])
      redirect_to @notification, :notice  => "Successfully updated notification."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_to notifications_url, :notice => "Successfully destroyed notification."
  end
end
