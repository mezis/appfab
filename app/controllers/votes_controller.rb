# encoding: UTF-8
class VotesController < ApplicationController
  include Traits::RequiresLogin
  include VotesHelper

  before_filter :load_idea_or_comment
  before_filter :parse_up_param, only: [:create]


  def create
    @vote = @subject.votes.new(params[:vote])
    @vote.user = current_user
    authorize! :vote, @subject if @vote.valid?

    if @vote.save
      flash[:success] = votes_message(@vote, :ok)
    else
      flash[:error] = votes_message(@vote, :fail)
    end

    respond_to do |format|
      format.html { redirect_to @return_to }
      format.js   { redirect_to @subject }
    end
  end

  def destroy
    @vote = @subject.votes.find(params[:id])
    @vote.destroy
    authorize! :destroy, @vote

    respond_to do |format|
      format.html { redirect_to @return_to, :notice => votes_message(@vote, :cancel) }
      format.js   { redirect_to @subject, status:303 }
    end
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
