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
    options_for_select(user.account.categories.sort.map { |category|
      [category, category]
    }, selected:idea.category)
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
    when :submitted   then s_('Idea state|submitted')    
    when :vetted      then s_('Idea state|vetted')
    when :voted       then s_('Idea state|voted')
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
    when 'rating'   then _('Sort by rating')
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
        s_('Tooltip|This idea cannot be backed yet.')
      else
        s_('Tooltip|This idea cannot be marked as %{state} yet.') % { :state => idea_status(state) }
      end
    else
      case state
      when :vetted
        s_('Tooltip|This idea has already been vetted.')
      when :voted
        s_('Tooltip|This idea cannot be backed anymore.')
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

    # %h4= _('Sorry! I\'m afraid there are no %{qualifier} ideas %{filter} %{category} at the moment.') % { qualifier: @angle, filter: ideas_filter_qualifier(@filter), category: ideas_category_qualifier(@category) }

  def ideas_copy_for_angle(angle)
    text = case angle
    when 'discussable' then _('This list show ideas currently open for discussion, regardless of their current status. Use the dropdowns to filter or sort them, or switch to another angle.')
    when 'vettable'    then _('This list show the ideas that need to be **vetted** before the can vote for them. This means that those ideas have not yet been looked at by a product manager or by an architect, or that their description is not precise enough yet for them to be properly sized.')
    when 'votable'     then _('Time to vote! This is the list of ideas that have been vetted and the team members can cast their vote on.')
    when 'pickable'    then _('This angle is only visible to product managers. Consider it your backlog of ideas to work on. It shows ideas that have received enough votes for you to consider them as worth working on.')
    when 'approvable'  then _('This angle is only visible to the benevolent dictator. It lists the ideas that have been picked by a product manager and have been designed; this means you should take a looks at their description and roadmap, their wireframes, and possibly preliminary designs, so product teams can start actually working on them.')
    when 'buildable'   then _('This angle lists ideas actively worked on: being designed by a product manager, implemented by a product team, or ready signed off and ready for release. It is the product team\'s working set.')
    when 'signoffable' then _('This angle is only visible to the benevolent dictator. It lists the ideas a product manager has marked as completed and awaits your sign off for release. See the idea details, or speak to your product manager to figure out where it was staged.')
    when 'followed'    then _('This angle lists the ides you are currently following. Remember, as soon as you participate on an idea (be it by commenting, vetting, or voting), we will bookmark it for you. You can un-bookmark ideas with the bottom-right icon on each idea card.')
    end

    pipeline_render text
  end
end

