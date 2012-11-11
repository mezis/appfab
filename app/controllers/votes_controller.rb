# encoding: UTF-8
class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_idea_or_comment
  before_filter :parse_up_param, only: [:create]

  def create
    @vote = @subject.votes.new(params[:vote])
    @vote.user = current_user

    if @vote.save
      flash[:success] = _("Vote cast successfully!")
    else
      flash[:error] = _("Failed to create vote.")
    end

    redirect_to @return_to
  end

  def destroy
    @vote = @subject.votes.find(params[:id])
    @vote.destroy
    redirect_to @return_to, :notice => _("Vote withdrawn.")
  end

  private

  def load_idea_or_comment
    if idea_id = params.delete(:idea_id)
      @subject = Idea.find(idea_id)
      @return_to = @subject
    else comment_id = params.delete(:comment_id)
      @subject = Comment.find(comment_id)
      @return_to = @subject.idea
    end
  end

  def parse_up_param
    return unless direction = params[:vote].andand[:up]
    params[:vote][:up] = case direction
      when /true/i  then true
      when /false/i then false
      else raise ArgumentError
    end
  end
end
