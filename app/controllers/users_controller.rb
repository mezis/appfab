class UsersController < ApplicationController
  include Traits::RequiresLogin

  before_filter :load_user, :only => [:show, :edit, :update, :destroy]

  def index
    unless current_account
      render_error_page :not_found,
        :message => _('You are not attached to an account, so there are no other users to display!')
      return
    end

    redirect_to account_path(current_account)
  end

  def show
    authorize! :read, @user
  end

  def edit
    authorize! :update, @user
  end

  def update
    authorize! :update, @user

    if @user.update_attributes(params[:user])
      redirect_to @user, :notice  => "Successfully updated user."
    else
      render :action => 'edit'
    end
  end

  def destroy
    authorize! :destroy, @user

    @user.destroy
    redirect_to users_url, :notice => "Successfully destroyed user."
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end
