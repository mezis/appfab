# encoding: UTF-8
class CommentsController < ApplicationController
  include Traits::RequiresLogin

  before_filter :load_comment, :only => [:show, :update, :destroy]

  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user
    authorize! :create, @comment if @comment.valid?

    success = @comment.save
      
    respond_to do |format|
      format.html do
        if success
          flash[:success] = _("Successfully posted comment.")
        else
          flash[:error] = _("Failed to post comment.")
        end

        if @comment.idea
          redirect_to idea_path(@comment.idea, anchor:dom_id(@comment))
        else
          redirect_to ideas_path
        end
      end
      format.js
    end
  end


  def show
    authorize! :read, @comment

    if request.xhr?
      case params['part']
      when 'attachments'
        render_ujs @comment.attachments, title:false, classes:'pull-right'
      end
      return
    end

    respond_to do |format|
      format.html { redirect_to idea_path(@comment.idea, anchor:dom_id(@comment)) }
      format.js
    end
  end


  def update
    authorize! :update, @comment

    if @comment.update_attributes(params[:comment])
      flash[:success] = _("Successfully updated comment.")
    else
      flash[:error] = _("Failed to update comment.")
    end
    redirect_to @comment.idea, anchor: 'comments'
  end


  def destroy
    authorize! :destroy, @comment
    @comment.destroy

    respond_to do |format|
      format.html do
        flash[:success] = _("Successfully destroyed comment.")
        redirect_to @comment.idea, anchor:'comments'
      end
      format.js
    end
  end

  private
  def load_comment
    @comment = Comment.find(params[:id])
  end
end
