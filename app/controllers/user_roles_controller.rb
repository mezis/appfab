# encoding: UTF-8
class UserRolesController < ApplicationController
  include Traits::RequiresLogin

  before_filter :load_user

  def create
    @user_role = @user.roles.new(user_role_params)
    if @user_role.save
      flash[:success] = _("Successfully created user role.")
    else
      flash[:error] = _("Failed to created user role.")
    end
    redirect_to @user
  end

  def destroy
    @user_role = @user.roles.find(params[:id])
    @user_role.destroy
    redirect_to @user, :notice => "Successfully destroyed user role."
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end

  def user_role_params
    params.require(:user_role).permit(:name)
  end
end
