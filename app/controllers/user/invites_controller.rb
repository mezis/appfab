require 'user_invitation_service'

class User::InvitesController < ApplicationController
  before_filter :authenticate_login!

  def create
    authorize! :invite, nil

    invitee = Login.new login_params
    invited = UserInvitationService.new(inviter:current_user, login:invitee).run

    if invited
      flash[:success] = _("Invite sent to %{user}") % { user: invitee.first_name }
    else
      flash[:notice] = _("No need, %{user} is already a member!") % { user: invitee.first_name }
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

  def login_params
    params.require(:login).permit(:email, :first_name, :last_name)
  end
end
