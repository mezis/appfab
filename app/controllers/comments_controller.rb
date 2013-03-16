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

    respond_to do |format|
      format.html do
        if @comment.idea
          redirect_to @comment.idea, anchor:dom_id(@comment)
        else
          redirect_to ideas_path
        end
      end
      format.js do
        unless @comment.id # not saved
          render nothing:true, status: :bad_request
        end
      end
    end
  end

  def show
    @comment = Comment.find(params[:id])

    if request.xhr?
      case params['part']
      when 'attachments'
        render_ujs @comment.attachments, title:false, classes:'pull-right'
      end
      return
    end

    respond_to do |format|
      format.html { redirect_to @comment.idea, anchor:dom_id(@comment) }
      format.js
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

    respond_to do |format|
      format.html { redirect_to @comment.idea, anchor:'comments' }
      format.js
    end
  end
end
