# encoding: UTF-8
class AccountsController < ApplicationController
  include Traits::RequiresLogin

  before_filter :load_account, :only => [:edit, :update, :destroy]

  def index
    redirect_to root_path
  end

  def show
    @account = Account.includes(:users => :login).find(params[:id])
    authorize! :read, @account
  end

  def new
    @account = Account.new
    authorize! :create, @account
  end

  def create
    authorize! :create, Account

    begin
      Account.transaction do
        @account = Account.new(account_params)
        @account.save!
        @account.users.create!(login:current_login).plays!(:account_owner, :submitter)
      end

      session[:account_id] = @account.id
      redirect_to @account, :notice => _("Successfully created team! Time to start inviting people.")
    rescue ActiveRecord::RecordInvalid
      render :new, :error => _("Failed to create team.")
    end
  end

  def edit
    authorize! :update, @account
  end

  def update
    authorize! :update, @account

    categories = account_params[:categories]
    if categories.kind_of?(String)
      account_params[:categories] = Set.new categories.split(/\s*,\s*/)
    end

    if @account.update_attributes(account_params)
      redirect_to @account, :notice  => _("Successfully updated team %{name}.") % { name:@account.name }
    else
      render :action => 'edit'
    end
  end

  def destroy
    authorize! :destroy, @account
    reset_login if @account == current_account
    @account.destroy
    redirect_to root_path, :notice => _("Successfully destroyed team %{name}.") % { name:@account.name }
  end

  private

  def load_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :categories)
  end
end
