# encoding: UTF-8
class IdeasController < ApplicationController
  before_filter :authenticate_login!
  before_filter :require_account!
  before_filter :cleanup_session
  before_filter :map_state_names, only:[:create, :update]
  before_filter :map_no_category, only:[:create, :update]

  ValidAngles = %w(discussable vettable votable pickable approvable signoffable buildable followed)
  DefaultAngle = ValidAngles.last

  ValidOrders  = %w(rating activity progress creation size)
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

  ValidViews = %w(cards board)
  DefaultView = ValidViews.first

  def index
    @angle    = set_angle_from_params
    @order    = set_order_from_params_and_angle
    @filter   = set_filter_from_params_and_angle
    @category = set_category_from_params_and_angle
    @view     = set_view_from_params

    @ideas = current_account.ideas.
      includes(:vettings).
      send(:"#{@angle}_by", current_user).
      send(:"by_#{@order}")
    @ideas = @ideas.send(:"#{@filter}_by", current_user) unless @filter == 'all'

    if @category == 'none'
      @ideas = @ideas.where(category: nil)
    elsif @category != 'all'
      @ideas = @ideas.where(category: @category)
    end
  end

  def show
    @just_created = flash[:just_created]
    flash.delete(:just_created)
    @idea = current_account.ideas.find(params[:id])
  end

  def new
    @idea = current_user.ideas.new
  end

  def create
    @idea = current_user.ideas.new(params[:idea])
    @idea.account = current_account
    if @idea.save
      flash[:just_created] = true
      redirect_to @idea
    else
      render :action => 'new'
    end
  end

  def edit
    @idea = current_account.ideas.find(params[:id])
  end

  def update
    @idea = current_account.ideas.find(params[:id])

    # specifics on state changes
    if state = params[:idea].andand[:state]
      # auto-set product manager when picking
      if state == Idea.state_value(:picked)
        @idea.product_manager = current_user
      end

      # if this is a draft promoted to submitted, flash :just_created
      if state == Idea.state_value(:submitted)
        flash[:just_created] = true
      end
    end

    if @idea.update_attributes(params[:idea])
      current_user.bookmarked_ideas.add!(@idea)
      redirect_to @idea, notice:_("Successfully updated idea.")
    else
      flash.discard
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

  def set_view_from_params
    params[:view] =
    session[:ideas_view] = begin
      (ValidViews.include?(params[:view])        and params[:view]) ||
      (ValidViews.include?(session[:ideas_view]) and session[:ideas_view]) ||
      session[:ideas_view] ||
      DefaultView
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
      valid_categories = (current_user.account.andand.categories || []) + %w(all none)
      (valid_categories.include?(params[:category])                and params[:category]) || 
      (valid_categories.include?(session[:ideas_category][@angle]) and session[:ideas_category][@angle]) || 
      'all'
    end
  end

  def map_state_names
    # map state names to values
    return unless state = params[:idea].andand[:state]
    params[:idea][:state] = Idea.state_value(state)
  end

  def map_no_category
    # map 'none' category to the valid nil
    return unless category = params[:idea].andand[:category]
    return unless category == 'none'
    params[:idea][:category] = nil
  end
end
