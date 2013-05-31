class AttachmentsController < ApplicationController
  include Traits::RequiresLogin
  before_filter :load_owner

  def show
    @attachment = @scope.find(params[:id])
  end

  def create
    Rails.logger.info params.inspect
    redirect_to @owner and return unless request.xhr?

    @attachment = @scope.new
    @attachment.file      = get_uploaded_file
    @attachment.name      = get_uploaded_file.andand.original_filename
    @attachment.mime_type = get_uploaded_file.andand.content_type
    @attachment.uploader  = current_user

    if @attachment.save
      respond_to do |format|
        format.json { render json: { success: true, id: @attachment.id }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false }, status: :bad_request }
      end
    end
  end

  def destroy
    @attachment = @scope.find(params[:id])
    @attachment.destroy

    flash[:notice] = _("Successfully destroyed attachment.")
    respond_to do |format|
      format.html { redirect_to(@owner || ideas_path) }
      format.js
    end
  end

  private

  def load_owner
    if params[:idea_id]
      @owner = Idea.find(params[:idea_id])
      @scope = @owner.attachments
    elsif params[:comment_id]
      @owner = Comment.find(params[:comment_id])
      @scope = @owner.attachments
    else
      @scope = Attachment
    end
  end

  def get_uploaded_file
    # obtain file from ActionDispatch's raw parameters,
    # as Rails' AJAX upload support is broken
    request.env['action_dispatch.request.request_parameters'].andand['attachment'].andand['file']
  end
end
