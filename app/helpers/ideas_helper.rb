# encoding: UTF-8
module IdeasHelper
  IdeaIcons = {
    bug:     'icon-fire',
    chore:   'icon-bar-chart',
    feature: 'icon-beaker',
  }

  def idea_kind_select_options
    options_for_select([
      [s_('Idea|Feature'), 'feature'],
      [s_('Idea|Chore'),   'chore'],
      [s_('Idea|Bug'),     'bug']
    ])
  end

  def idea_category_select_options(user, idea)
    pairs = user.account.categories.sort.map { |category| [category, category] }
    pairs.unshift [_('Unspecified'), 'none']
    pairs.unshift [_('Pick a category'), nil]
    options_for_select(pairs, selected:(idea.category || 'none'))
  end

  def idea_size_human(size)
    case size
    when 1 then s_('T-shirt size|XS')
    when 2 then s_('T-shirt size|S')
    when 3 then s_('T-shirt size|M')
    when 4 then s_('T-shirt size|L')
    end
  end

  def idea_size_human_long(size)
    case size
    when 1 then s_('T-shirt size|Extra-small')
    when 2 then s_('T-shirt size|Small')
    when 3 then s_('T-shirt size|Medium')
    when 4 then s_('T-shirt size|Large')
    else raise ArgumentError
    end
  end

  def idea_status(state)
    state = state.to_sym if state.kind_of?(String)
    case state
    when :draft       then s_('Idea state|draft')
    when :submitted   then s_('Idea state|submitted')    
    when :vetted      then s_('Idea state|vetted')
    when :voted       then s_('Idea state|endorsed')
    when :picked      then s_('Idea state|picked')    
    when :designed    then s_('Idea state|designed')      
    when :approved    then s_('Idea state|approved')      
    when :implemented then s_('Idea state|implemented')        
    when :signed_off  then s_('Idea state|signed off')        
    when :live        then s_('Idea state|live')
    else raise ArgumentError
    end
  end

  def idea_size_type_name(field)
    case field.to_s
    when 'design_size'      then s_('Idea size|Design size')
    when 'development_size' then s_('Idea size|Development size')
    else raise ArgumentError
    end
  end

  def idea_order_human(order)
    case order
    when 'impact'   then _('Sort by impact')
    when 'activity' then _('Sort by activity')
    when 'progress' then _('Sort by progress')
    when 'creation' then _('Sort by creation')
    when 'size'     then _('Sort by size')
    else raise ArgumentError
    end
  end

  def idea_filter_human(filter)
    case filter
    when 'all'       then _('Unfiltered')
    when 'authored'  then _('Your ideas')
    when 'commented' then _('Commented by you')
    when 'vetted'    then _('Vetted by you')
    when 'backed'    then _('Backed by you')
    end
  end

  def idea_view_icon(view)
    case view
    when 'cards' then 'icon-list-alt'
    when 'board' then 'icon-columns'
    when 'list'  then 'icon-table'
    else raise ArgumentError
    end
  end

  # +state+ is the target state of the action
  def idea_unavailable_action_tooptip(idea, state)
    if idea.is_state_in_future?(state)
      case state
      when :vetted
        s_('Tooltip|This idea cannot be vetted yet.')
      when :voted
        s_('Tooltip|This idea cannot be endorsed yet.')
      else
        s_('Tooltip|This idea cannot be marked as %{state} yet.') % { :state => idea_status(state) }
      end
    else
      case state
      when :vetted
        s_('Tooltip|This idea has already been vetted.')
      when :voted
        s_('Tooltip|This idea cannot be endorsed anymore.')
      else
        s_('Tooltip|This idea has already been %{state}.') % { :state => idea_status(state) }
      end
    end
  end


  def ideas_filter_qualifier(filter)
    case filter
    when 'authored'  then _('that you authored')
    when 'commented' then _('that you commented')
    when 'vetted'    then _('that you vetted')
    when 'backed'    then _('that you backed')
    when 'all'       then nil
    else raise ArgumentError
    end
  end

  def ideas_category_qualifier(category)
    case category
    when 'none'
      _('without a category')
    when 'all'
      nil
    else
      _('in the "%{category}" category') % { category:category }
    end
  end

  def ideas_copy_for_angle(angle)
    text = case angle
    when 'discussable' then _('This list show ideas currently open for discussion, regardless of their current status. Use the dropdowns to filter or sort them.')
    when 'followed'    then _('This angle lists the ideas you are currently following. Remember, as soon as you participate on an idea (be it by commenting, vetting, or voting), we will bookmark it for you. You can un-bookmark ideas with the bottom-right icon on each idea card.')
    else 
      _("Ow, I'm not sure how you landed here. This doesn't look like a view I knwo about, sorry!")
    end

    pipeline_render text
  end

  def ideas_view_tooltip(view)
    case view
    when 'cards' then s_('Tooltip|Show ideas in card view')
    when 'board' then s_('Tooltip|Show ideas in board view')
    else raise ArgumentError
    end
  end

  def ideas_board_states
    IdeaStateMachine.all_state_names - [:draft]
  end


  def idea_copy_for_state(state_name)
    case state_name
    when :draft
      _("This idea is a draft: only you can see it in lists of ideas, although other users can view it if you give the a link. You can edit it until it's ready for submission.")
    when :submitted
      _("This idea was submitted, but is not vetted yet. It needs to be looked at by both a product manager and an architect, each of whom will estimate the effort involved and vet it. They also can just comment on it and ask you to provide more details, give it a better title, or elaborate on the problem statement for instance: only specific, precise ideas can be sized properly.")
    when :vetted
      _("This idea has been vetted by a product manager and an architect, but has not received enough endorsements yet, so no team can pick it up and start working on it. There is a minimum of %{minimum_votes} endorsements for an idea to proceed.") % { minimum_votes:§.votes_needed }
    when :voted
      _("Great! This idea has received more than the minimum endorsements. Assuming it is or becomes one of the top rated ideas, a product team will pick it up and start working on it.")
    when :picked
      _("This idea has been picked by a product manager. This is the design phase: development has not started yet, but the product team is planning to. The outcome may be a detailed roadmap, an identified 'minimum viable product' line, and a set of wireframes for instance. Oh, and everyone who backed it got a bit of extra %{karma}.") % { karma:user_karma_symbol }
    when :designed
      _("This idea has been designed by a product team: at this point they know almost exactly what to do, and have a good idea of the roadmap and time to first release. It is waiting for an approval by the 'benevolent dictator'.")
    when :approved
      _("This idea has been designed and approved. The product team that picked it up is working its magic (which might involve writing code) to implement it.")
    when :implemented
      _("This idea has been picked, designed, implemented, and fully tested. It should be demo-able in a staging environment, and is just waiting for the 'benevolent dictator' to sign it off before release.")
    when :signed_off
      _("Awesome! This idea has been signed off, and is ready to go live. It's just a matter of running regression tests and planning a release now, almost there!")
    when :live
      _("Wow, just wow. This idea is live. Oh and by the way—the author and eveyone who backed this idea just got some extra %{karma}.") % { karma:user_karma_symbol }
    end
  end

  def idea_force_action_confimation
    _('You are acting on behalf of the Benevolent Dictator. Are you sure?')
  end

  def idea_category_class(idea)
    account_category_class(idea.account, idea.category)
  end

  def idea_rating_message(idea)
    if Rails.env.development?
      "stars: #{idea.stars_cache}, impact: #{idea.impact_cache}, development size: #{idea.development_size}, design size: #{idea.design_size}, votes: #{idea.votes_cache}, vote weight: #{idea.rating}"
    else
      if idea.star_rating
        _('The current impact rating of this idea. It is calculated from the number of votes it has received, weighed by the voting power of each voter, and divided by the estimated effort for this idea.')
      else
         _('This idea has no impact rating.')
      end
    end
  end
end

