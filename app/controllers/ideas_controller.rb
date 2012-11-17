# encoding: UTF-8
class IdeasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :cleanup_session

  ValidAngles = %w(discussable vettable votable pickable approvable signoffable buildable followed)
  DefaultAngle = ValidAngles.last

  ValidOrders  = %w(rating activity progress creation)
  DefaultOrder = {
    'discussable' => 'activity',
    'vettable'    => 'activity',
    'votable'     => 'activity',
    'pickable'    => 'rating',
    'approvable'  => 'activity',
    'buildable'   => 'progress',
    'signoffable' => 'activity',
    'followed'    => 'activity'
  }

  ValidFilters = %w(all authored commented vetted backed)
  DefaultFilter = ValidFilters.first

  def index
    @angle    = set_angle_from_params
    @order    = set_order_from_params_and_angle
    @filter   = set_filter_from_params_and_angle
    @category = set_category_from_params_and_angle
    @ideas = Idea.
      send(:"#{@angle}_by", current_user).
      send(:"by_#{@order}")
    @ideas = @ideas.send(:"#{@filter}_by", current_user) unless @filter   == 'all'
    @ideas = @ideas.where(category: @category) unless @category == 'all'
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

    # state changes: map state names to values
    if state = params[:idea].andand[:state]
      @idea.product_manager = current_user if state == 'picked'
      params[:idea][:state] = Idea.state_value(state)
    end

    if @idea.update_attributes(params[:idea])
      current_user.bookmarked_ideas.add!(@idea)
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

  def cleanup_session
    session.delete :ideas_angle  unless session[:ideas_angle].kind_of?(String)
    session.delete :ideas_order  unless session[:ideas_order].kind_of?(Hash)
    session.delete :ideas_filter unless session[:ideas_filter].kind_of?(Hash)
  end

  def set_angle_from_params
    params[:angle] =
    session[:ideas_angle] = begin
      (ValidAngles.include?(params[:angle])        and params[:angle]) ||
      (ValidAngles.include?(session[:ideas_angle]) and session[:ideas_angle]) ||
      session[:ideas_angle] ||
      DefaultAngle
    end
  end

  def set_order_from_params_and_angle
    session[:ideas_order] ||= {}
    params[:order] =
    session[:ideas_order][@angle] = begin
      (ValidOrders.include?(params[:order])                and params[:order]) || 
      (ValidOrders.include?(session[:ideas_order][@angle]) and session[:ideas_order][@angle]) || 
      DefaultOrder[@angle]
    end
  end

  def set_filter_from_params_and_angle
    session[:ideas_filter] ||= {}
    params[:filter] =
    session[:ideas_filter][@angle] = begin
      (ValidFilters.include?(params[:filter])                and params[:filter]) || 
      (ValidFilters.include?(session[:ideas_filter][@angle]) and session[:ideas_filter][@angle]) || 
      DefaultFilter
    end
  end

  def set_category_from_params_and_angle
    session[:ideas_category] ||= {}
    params[:category] =
    session[:ideas_category][@angle] = begin
      valid_categories = (current_user.account.andand.categories || []) + %w(all)
      (valid_categories.include?(params[:category])                and params[:category]) || 
      (valid_categories.include?(session[:ideas_category][@angle]) and session[:ideas_category][@angle]) || 
      'all'
    end
  end
end
