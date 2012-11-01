# encoding: UTF-8
class UserRolesController < ApplicationController
  def index
    @user_roles = UserRole.all
  end

  def show
    @user_role = UserRole.find(params[:id])
  end

  def new
    @user_role = UserRole.new
  end

  def create
    @user_role = UserRole.new(params[:user_role])
    if @user_role.save
      redirect_to @user_role, :notice => "Successfully created user role."
    else
      render :action => 'new'
    end
  end

  def edit
    @user_role = UserRole.find(params[:id])
  end

  def update
    @user_role = UserRole.find(params[:id])
    if @user_role.update_attributes(params[:user_role])
      redirect_to @user_role, :notice  => "Successfully updated user role."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user_role = UserRole.find(params[:id])
    @user_role.destroy
    redirect_to user_roles_url, :notice => "Successfully destroyed user role."
  end
end
