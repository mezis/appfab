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

  def idea_icon_for_kind(idea, options = {})
    classes = options.fetch(:class, '').split
    classes.push IdeaIcons[idea.kind.to_sym]
    content_tag(:i, '', options.merge(class: safe_join(classes.uniq, ' ')))
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
    end
  end

  def idea_status(idea)
    case idea.state
    when 'submitted'   then s_('Idea state|submitted')    
    when 'vetted'      then s_('Idea state|vetted')
    when 'picked'      then s_('Idea state|picked')    
    when 'designed'    then s_('Idea state|designed')      
    when 'approved'    then s_('Idea state|approved')      
    when 'implemented' then s_('Idea state|implemented')        
    when 'signed_off'  then s_('Idea state|signed_off')        
    when 'live'        then s_('Idea state|live')
    end
  end
end

