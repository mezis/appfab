# encoding: UTF-8
class VettingsController < ApplicationController
  before_filter :load_idea

  def index
    @vettings = Vetting.all
  end

  def show
    @vetting = Vetting.find(params[:id])
  end

  def new
    @vetting = Vetting.new
  end

  def create
    @vetting = Vetting.new(params[:vetting])
    if @vetting.save
      redirect_to @vetting, :notice => "Successfully created vetting."
    else
      render :action => 'new'
    end
  end

  def edit
    @vetting = Vetting.find(params[:id])
  end

  def update
    @vetting = Vetting.find(params[:id])
    if @vetting.update_attributes(params[:vetting])
      redirect_to @vetting, :notice  => "Successfully updated vetting."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @vetting = Vetting.find(params[:id])
    @vetting.destroy
    redirect_to vettings_url, :notice => "Successfully destroyed vetting."
  end

  private

  def load_idea
    return unless params[:idea_id]
    @idea = Idea.find(params[:idea_id])
  end
end
