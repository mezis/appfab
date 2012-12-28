# encoding: UTF-8
class AccountsController < ApplicationController
  before_filter :authenticate_login!

  def show
    @account = Account.find(params[:id])
    authorize! :read, @account
  end

  def new
    @account = Account.new
    authorize! :create, @account
  end

  def create
    @account = Account.new(params[:account])
    authorize! :create, @account
    if @account.save
      redirect_to @account, :notice => "Successfully created account."
    else
      render :action => 'new'
    end
  end

  def edit
    @account = Account.find(params[:id])
    authorize! :update, @account
  end

  def update
    @account = Account.find(params[:id])
    authorize! :update, @account

    categories = params[:account].andand.delete(:categories)
    if categories.kind_of?(String)
      params[:account][:categories] = Set.new categories.split(/\s*,\s*/)
    end

    if @account.update_attributes(params[:account])
      redirect_to @account, :notice  => "Successfully updated account."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])
    authorize! :destroy, @account
    @account.destroy
    redirect_to accounts_url, :notice => "Successfully destroyed account."
  end
end
