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

    if request.xhr?
      render partial: 'users/tooltip', locals:{ user: @user }
    end
  end

  def edit
    authorize! :update, @user
    @form = User::EditForm.new(@user)
  end

  def update
    authorize! :update, @user
    @form = User::EditForm.new(@user)

    if @form.needs_admin_rights?(params[:user])
      authorize! :update_admin, @user
    end

    if @form.update_attributes(params[:user])
      redirect_to @user, :notice  => _("Successfully updated user profile.")
    else
      render action: 'edit'
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
