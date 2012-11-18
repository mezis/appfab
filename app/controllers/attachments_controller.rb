class AttachmentsController < ApplicationController
  before_filter :authenticate_user!
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
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: 400
    end
  end

  def destroy
    @attachment = @idea.attachments.find(params[:id])
    @attachment.destroy
    redirect_to @idea, :notice => _("Successfully destroyed attachment.")
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
