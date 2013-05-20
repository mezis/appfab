module DashboardsHelper
  def dashboard_render(dashboard, variant_name)
    variant = DASHBOARD_VARIANTS[variant_name]

    render 'ideas/list', 
      ideas:   dashboard.send(:"ideas_#{variant_name}"), 
      title:   variant.title,
      icon:    variant.icon,
      padding: dashboard.block_size
  end

  private

  DASHBOARD_VARIANTS = {
    to_size: OpenStruct.new(
      title: _('Ideas to size'),
      icon:  'wrench'
    ),
    recently_active: OpenStruct.new(
      title: _('Recently active ideas'),
      icon:  'time'
    ),
    for_dictator: OpenStruct.new(
      title: _('Ideas to approve / sign off'),
      icon:  'ok-sign'
    ),
    to_vote: OpenStruct.new(
      title: _('Ideas to endorse'),
      icon:  'thumbs-up'
    ),
    recently_submitted: OpenStruct.new(
      title: _('Recently submitted'),
      icon:  'edit'
    ),
    working_set: OpenStruct.new(
      title: _('Currently worked on'),
      icon:  'cog'
    )
  }
end

__END__

