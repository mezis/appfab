class AttachedFilesController < ApplicationController
  def index
    @attached_files = AttachedFile.all
  end

  def show
    @attached_file = AttachedFile.find(params[:id])
  end

  def new
    @attached_file = AttachedFile.new
  end

  def create
    @attached_file = AttachedFile.new(params[:attached_file])
    if @attached_file.save
      redirect_to @attached_file, :notice => "Successfully created attached_file."
    else
      render :action => 'new'
    end
  end

  def edit
    @attached_file = AttachedFile.find(params[:id])
  end

  def update
    @attached_file = AttachedFile.find(params[:id])
    if @attached_file.update_attributes(params[:attached_file])
      redirect_to @attached_file, :notice  => "Successfully updated attached_file."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @attached_file = AttachedFile.find(params[:id])
    @attached_file.destroy
    redirect_to attached_files_url, :notice => "Successfully destroyed attached_file."
  end
end
