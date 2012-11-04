# encoding: UTF-8
class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_idea

  def create
    @vote = @idea.votes.new
    @vote.user = current_user

    if @vote.save
      flash[:success] = _("Vote cast successfully!")
    else
      flash[:error] = _("Failed to create vote.")
    end

    redirect_to @idea
  end

  def destroy
    @vote = @idea.votes.find(params[:id])
    @vote.destroy
    redirect_to @idea, :notice => _("Vote withdrawn.")
  end

  private

  def load_idea
    @idea = Idea.find(params.delete(:idea_id))
  end
end
