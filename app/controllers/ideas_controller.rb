# encoding: UTF-8
class IdeasController < ApplicationController
  include Traits::RequiresLogin

  before_filter :require_account!
  before_filter :cleanup_session
  before_filter :map_state_names,        only:[:create, :update]
  before_filter :map_product_manager_id, only:[:update]
  before_filter :map_no_category,        only:[:create, :update]
  before_filter :can_create_idea,        only:[:new, :create]

  VALID_ANGLES = %w(discussable followed)
  DEFAULT_ANGLE = VALID_ANGLES.last

  VALID_ORDERS  = %w(impact activity progress creation)
  DEFAULT_ORDER = VALID_ORDERS.first

  VALID_FILTERS = %w(all authored commented vetted backed)
  DEFAULT_FILTER = VALID_FILTERS.first

  VALID_VIEWS = %w(cards board)
  DEFAULT_VIEW = VALID_VIEWS.first

  LIMIT_RANGE = 5..100
  DEFAULT_LIMIT = { 'board' => 6, 'cards' => 12 }

  def index
    @angle    = set_angle_from_params
    @order    = set_order_from_params_and_angle
    @filter   = set_filter_from_params_and_angle
    @category = set_category_from_params_and_angle
    @view     = set_view_from_params
    @limit    = set_limit_from_params(@view)
    @state    = set_state_from_params


    # account, angle and filter
    @ideas = current_account.ideas
    @ideas = @ideas.send(:"#{@angle}_by", current_user)
    @ideas = @ideas.send(:"#{@filter}_by", current_user) unless @filter == 'all'

    if @category == 'none'
      @ideas = @ideas.where(category: nil)
    elsif @category != 'all'
      @ideas = @ideas.where(category: @category)
    end

    @ideas = @ideas.with_state(@state.to_sym) unless @state == 'all'

    # counts before ordering and pagination
    @idea_counts = @ideas.counts_per_state if @view == 'board'

    # order
    @ideas = @ideas.send(:"by_#{@order}")

    # pagination
    case @view
    when 'board'
      @ideas = @ideas.limit_per_state(limit:@limit)
    else
      @ideas = @ideas.paginate(page:1, per_page:@limit)
    end

    # eager-load participants
    @ideas = @ideas.includes(:participants => :login)
  end

  def show
    @idea = find_idea(params[:id])
    self.current_account = @idea.account

    @just_submitted = session.delete(:just_submitted)

    if request.xhr?
      case params['part']
      when 'attachments'
        render_ujs @idea.attachments
      else
        render nothing:true, status:400
      end
    end
  end

  def new
    @idea = current_user.ideas.new
  end

  def create
    @idea = current_user.ideas.new(params[:idea])
    @idea.account = current_account
    if @idea.save
      session[:just_submitted] = true
      redirect_to @idea
    else
      render :action => 'new'
    end
  end

  def edit
    @idea = find_idea(params[:id])
  end

  def update
    @idea = find_idea(params[:id])

    # specifics on account change
    if new_account_id = params[:idea].andand.delete(:account_id)
      update_account @idea, new_account_id
      return
    end

    # specifics on state changes
    if state = params[:idea].andand.delete(:state)
      # auto-set product manager when picking
      if state == IdeaStateMachine.state_value(:picked)
        @idea.product_manager = current_user
      end

      if @idea.state_machine.draft? && state == IdeaStateMachine.state_value(:submitted)
        # this is a draft promoted to submitted
        session[:just_submitted] = true
      end

      @idea.state = state
      IdeaStateMachineService.new(@idea).run
    end

    if @idea.update_attributes(params[:idea])
      current_user.bookmarked_ideas.add!(@idea)
      redirect_to @idea, notice:_("Successfully updated idea.")
    else
      session.delete(:just_submitted)
      render :action => 'edit'
    end
  end

  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy
    redirect_to ideas_url, :notice => "Successfully destroyed idea."
  end


  private
  include AuthorizationHelper

  def update_account(idea, new_account_id)
    new_account = Account.find(new_account_id)

    # check autorization
    unless can?(:move, @idea)
      flash[:error] = _('You cannot move this idea unless you are the author, the product manager, or an account owner.')
      redirect_to @idea
      return
    end

    unless current_login.accounts.include?(new_account)
      flash[:error] = _('You must be a member of the target account to move and idea there.')
      redirect_to @idea
      return
    end

    IdeaMoverService.new(idea:@idea, account:new_account).run
    flash[:notice] = _('Successfully changed idea account')
    redirect_to @idea
  end


  def find_idea(id)
    idea = Idea.where(account_id:current_login.accounts.value_of(:id)).find(id)
    self.current_account = idea.account
    return idea
  end

  def cleanup_session
    {
      ideas_angle:  String,
      ideas_order:  Hash,
      ideas_filter: Hash
    }.each_pair do |session_key, type|
      next if session[session_key].kind_of?(type)
      session.delete(session_key)
    end
  end

  def set_angle_from_params
    params[:angle] =
    session[:ideas_angle] = begin
      (VALID_ANGLES.include?(params[:angle])        and params[:angle]) ||
      (VALID_ANGLES.include?(session[:ideas_angle]) and session[:ideas_angle]) ||
      session[:ideas_angle] ||
      DEFAULT_ANGLE
    end
  end

  def set_view_from_params
    params[:view] =
    session[:ideas_view] = begin
      (VALID_VIEWS.include?(params[:view])        and params[:view]) ||
      (VALID_VIEWS.include?(session[:ideas_view]) and session[:ideas_view]) ||
      session[:ideas_view] ||
      DEFAULT_VIEW
    end
  end

  def set_order_from_params_and_angle
    session[:ideas_order] ||= {}
    params[:order] =
    session[:ideas_order][@angle] = begin
      (VALID_ORDERS.include?(params[:order])                and params[:order]) ||
      (VALID_ORDERS.include?(session[:ideas_order][@angle]) and session[:ideas_order][@angle]) ||
      DEFAULT_ORDER
    end
  end

  def set_filter_from_params_and_angle
    session[:ideas_filter] ||= {}
    params[:filter] =
    session[:ideas_filter][@angle] = begin
      (VALID_FILTERS.include?(params[:filter])                and params[:filter]) ||
      (VALID_FILTERS.include?(session[:ideas_filter][@angle]) and session[:ideas_filter][@angle]) ||
      DEFAULT_FILTER
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


  def set_limit_from_params(view)
    @limit = begin
      limit = params[:limit].to_i rescue 0
      LIMIT_RANGE.include?(limit) ? limit : DEFAULT_LIMIT[view]
    end
  end


  VALID_STATES = IdeaStateMachine.all_state_names.map(&:to_s)
  def set_state_from_params
    @state = begin
      state = params.fetch(:state, 'all')
      VALID_STATES.include?(state) ? state : 'all'
    end
  end


  # map state names to values
  def map_state_names
    return unless state = params[:idea].andand[:state]
    params[:idea][:state] = IdeaStateMachine.state_value(state)
  end


  # map 'none' category to the valid nil
  def map_no_category
    return unless category = params[:idea].andand[:category]
    return unless category == 'none'
    params[:idea][:category] = nil
  end


  # replace user id with a user instance
  def map_product_manager_id
    return unless product_manager_id = params[:idea].andand.delete(:product_manager_id)
    params[:idea][:product_manager] = current_account.users.find(product_manager_id)
  end


  def can_create_idea
    return if can?(:create, Idea)
    flash[:error] = not_authorized_message(:create, Idea)
    redirect_back_or_to ideas_path
  end
end
