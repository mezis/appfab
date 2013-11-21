class SessionsController < ApplicationController
  include Traits::RequiresLogin

  def update
    if params[:account_id]
      switch_account params[:account_id].to_i
    elsif params[:user_id]
      act_as_user params[:user_id].to_i
    else
      flash[:error] = _("Oops, sorry, we didn't quite get that.")
    end
    redirect_to ideas_path
  end


  private


  def switch_account(account_id)
    unless current_login.accounts.pluck(:id).include?(account_id)
      flash[:error] = _("Oops, you're not a member of that account.")
      return
    end

    if acting_real_user
      flash[:error] = _("Sorry, you cannot switch accounts when assuming another user's identity.")
      return
    end

    account = Account.find(account_id)
    session[:account_id] = account.id
    flash[:success] = _("Welcome back to team %{name}, %{user}!") % { name:account.name, user:current_login.first_name }
    reset_login
  end


  def act_as_user(user_id)
    assumed_user = current_account.users.find_by_id(user_id)
    unless assumed_user
      flash[:error] = _("Oops, we could not find the user you're trying to act as.")
      return
    end

    if assumed_user == acting_real_user
      # no further checks if switching back
      self.acting_real_user = nil
    else
      if acting_real_user
        flash[:error] = _("Sorry, you cannot act as a user when already assuming another user's identity.")
        return
      end

      if !current_user.plays?(:account_owner)
        flash[:error] = _("Oops, you're not owner of that account.")
        return
      end

      self.acting_real_user = current_user
    end

    sign_in(assumed_user.login)
    session[:account_id] = assumed_user.account.id
    reset_login
  end
end
