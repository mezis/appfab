require 'user_invitation_service'

class User::InvitesController < ApplicationController
  before_filter :authenticate_login!

  def create
    invitee = Login.new params[:login].slice(:email, :first_name, :last_name)
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
end
