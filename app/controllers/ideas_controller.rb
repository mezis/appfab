# encoding: UTF-8
class IdeasController < ApplicationController
  before_filter :authenticate_user!

  ValidAngles = %w(discussable vettable votable buildable followed)
  DefaultAngle = ValidAngles.last

  ValidOrders  = %w(rating activity progress creation)
  DefaultOrder = ValidOrders.last

  ValidFilters = %w(all authored commented vetted backed)
  DefaultFilter = ValidFilters.first

  def index
    @angle  = get_angle_from_params
    @order  = session[:ideas_order]  = get_order_from_params
    @filter = session[:ideas_filter] = get_filter_from_params
    @ideas = Idea.
      send(:"#{@angle}_by", current_user).
      send(:"by_#{@order}")
    @ideas = @ideas.send(:"#{@filter}_by", current_user) unless @filter == 'all'
  end

  def show
    @idea = Idea.find(params[:id])
  end

  def new
    @idea = current_user.ideas.new
  end

  def create
    @idea = current_user.ideas.new(params[:idea])
    if @idea.save
      redirect_to @idea, :notice => _("Successfully submitted idea.")
    else
      render :action => 'new'
    end
  end

  def edit
    @idea = Idea.find(params[:id])
  end

  def update
    @idea = Idea.find(params[:id])

    @idea.product_manager = current_user if params[:idea].andand[:state] == 'picked'

    if @idea.update_attributes(params[:idea])
      redirect_to @idea, :notice  => "Successfully updated idea."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy
    redirect_to ideas_url, :notice => "Successfully destroyed idea."
  end


  private


  def get_angle_from_params
    return params[:angle] if ValidAngles.include?(params[:angle])
    DefaultAngle
  end

  def get_order_from_params
    return params[:order] if ValidOrders.include?(params[:order])
    session[:ideas_order] || DefaultOrder
  end

  def get_filter_from_params
    return params[:filter] if ValidFilters.include?(params[:filter])
    session[:ideas_filter] || DefaultFilter
  end
end
