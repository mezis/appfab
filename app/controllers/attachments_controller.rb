class AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.all
  end

  def show
    @attachment = Attachment.find(params[:id])
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new(params[:attachment])
    if @attachment.save
      redirect_to @attachment, :notice => "Successfully created attachment."
    else
      render :action => 'new'
    end
  end

  def edit
    @attachment = Attachment.find(params[:id])
  end

  def update
    @attachment = Attachment.find(params[:id])
    if @attachment.update_attributes(params[:attachment])
      redirect_to @attachment, :notice  => "Successfully updated attachment."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to attachments_url, :notice => "Successfully destroyed attachment."
  end
end
