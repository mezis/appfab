module DashboardsHelper
  def dashboard_render(dashboard, variant_name)
    @dashboard_render_blocks ||= 0
    @dashboard_render_blocks += 1

    variant = DASHBOARD_VARIANTS[variant_name]

    render 'application/block_list', 
      collection: dashboard.send(variant_name),
      title:      variant.title,
      icon:       variant.icon,
      padding:    dashboard.block_size,
      format:     'line'
  end

  def dashboard_render_extra_blocks
    count = { 0 => 0, 1 => 2, 2 => 1 }[@dashboard_render_blocks % 3]
  end

  private

  DASHBOARD_VARIANTS = {
    ideas_to_size: OpenStruct.new(
      title: _('Ideas to size'),
      icon:  'wrench'
    ),
    ideas_recently_active: OpenStruct.new(
      title: _('Recently active ideas'),
      icon:  'time'
    ),
    ideas_for_dictator: OpenStruct.new(
      title: _('Ideas to approve / sign off'),
      icon:  'ok-sign'
    ),
    ideas_to_vote: OpenStruct.new(
      title: _('Ideas to endorse'),
      icon:  'thumbs-up'
    ),
    ideas_recently_submitted: OpenStruct.new(
      title: _('Recently submitted'),
      icon:  'edit'
    ),
    ideas_working_set: OpenStruct.new(
      title: _('Currently worked on'),
      icon:  'cog'
    ),
    notifications_recent: OpenStruct.new(
      title: _('Recent notifications'),
      icon:  'inbox'
    ),
    comments_on_followed_ideas: OpenStruct.new(
      title: _('Recent comments'),
      icon:  'comment'
    )
  }
end

__END__

