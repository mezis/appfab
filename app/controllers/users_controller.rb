class UsersController < ApplicationController
  include Traits::RequiresLogin
  UPDATABLE_ATTRIBUTES = %w(first_name last_name voting_power state)
  ADMIN_ATTRIBUTES = %w(voting_power state)

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

    changes = params.fetch(:user, {})
    if (changes.keys - UPDATABLE_ATTRIBUTES).any?
      render_error_page :bad_request and return
    end

    if (changes.keys & ADMIN_ATTRIBUTES).any?
      authorize! :update_admin, @user
    end

    if @user.update_attributes(changes)
      redirect_to @user, :notice  => _("Successfully updated user profile.")
    else
      render :action => 'edit'
    end
  end

  def destroy
    authorize! :destroy, @user

    @user.destroy
    redirect_to users_url, :notice => _("Successfully destroyed user.")
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end
