class AttachmentsController < ApplicationController
  before_filter :authenticate_login!
  before_filter :load_idea

  def show
    @attachment = @idea.attachments.find(params[:id])
  end

  def create
    redirect_to @idea and return unless request.xhr?

    @attachment = @idea.attachments.new
    @attachment.file      = get_uploaded_file
    @attachment.name      = get_uploaded_file.andand.original_filename
    @attachment.mime_type = get_uploaded_file.andand.content_type
    @attachment.uploader  = current_user

    if @attachment.save
      respond_to do |format|
        format.json { render json: { success: true, id:@attachment.id }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false }, status: :bad_request }
      end
    end
  end

  def destroy
    @attachment = @idea.attachments.find(params[:id])
    @attachment.destroy

    flash[:notice] = _("Successfully destroyed attachment.")
    respond_to do |format|
      format.html { redirect_to @idea }
      format.js
    end
  end

  private

  def load_idea
    @idea = Idea.find(params[:idea_id])
  end

  def get_uploaded_file
    # obtain file from ActionDispatch's raw parameters,
    # as Rails' AJAX upload support is broken
    request.env['action_dispatch.request.request_parameters'].andand['attachment'].andand['file']
  end
end
