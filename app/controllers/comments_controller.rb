# encoding: UTF-8
class CommentsController < ApplicationController
  before_filter :authenticate_login!

  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user

    if @comment.save
      flash[:success] = _("Successfully posted comment.")
    else
      flash[:error] = _("Failed to post comment.")
    end

    if @comment.idea
      redirect_to @comment.idea, anchor: 'comments'
    else
      redirect_to ideas_path
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:success] = _("Successfully updated comment.")
    else
      flash[:error] = _("Failed to update comment.")
    end
    redirect_to @comment.idea, anchor: 'comments'
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = _("Successfully destroyed comment.")
    redirect_to @comment.idea, anchor: 'comments'
  end
end
