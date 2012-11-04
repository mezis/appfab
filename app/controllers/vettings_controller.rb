# encoding: UTF-8
class VettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_idea

  def create
    @vetting = @idea.vettings.new(params[:vetting])
    @vetting.user = current_user

    if @vetting.save
      flash[:success] = _("Successfully created vetting.")
    else
      flash[:error] = _("Failed to create vetting.")
    end

    redirect_to @idea
  end

  def destroy
    @vetting = @idea.vettings.find(params[:id])
    @vetting.destroy
    redirect_to @idea, :notice => _("Successfully destroyed vetting.")
  end

  private

  def load_idea
    @idea = Idea.find(params.delete(:idea_id))
  end
end
