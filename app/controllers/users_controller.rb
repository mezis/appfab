class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    unless current_account
      render_error_page :not_found,
        :message => _('You are not attached to an account, so there are no other users to display!')
      return
    end

    redirect_to account_path(current_account)
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end

  def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    if @user.update_attributes(params[:user])
      redirect_to @user, :notice  => "Successfully updated user."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user

    @user.destroy
    redirect_to users_url, :notice => "Successfully destroyed user."
  end
end
