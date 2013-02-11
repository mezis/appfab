module HeaderHelper

  def header_angle_counter(angle)
    return unless current_account
    count = current_account.ideas.send(:"#{angle}_by", current_user).count
    return if count == 0
    content_tag(:div, count, class:'badge ht-badge-offset ht-badge-small ht-badge-muted')
  end
end