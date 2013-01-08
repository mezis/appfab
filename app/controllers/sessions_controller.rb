class SessionsController < ApplicationController
  before_filter :authenticate_login!

  def update
    unless params[:account_id]
      flash[:error] = _("Oops, sorry, we didn't quite get that.")
      redirect_to ideas_path and return
    end

    account_id = params[:account_id].to_i

    unless current_login.accounts.value_of(:id).include?(account_id)
      flash[:error] = _("Oops, you're not a member of that account.")
      redirect_to ideas_path and return
    end

    session[:account_id] = account_id
    account = Account.find(account_id)
    flash[:success] = _("Welcome back to team %{name}, %{user}!") % { name:account.name, user:current_login.first_name }
    redirect_to ideas_path and return
  end
end
