module AuthorizationHelper
  def not_authorized_message(action, object)
    case action
    when :update, :vet, :destroy, :edit, :pick
      _('Sorry, you may not %{verb} this %{object}.') % { verb: action, object: _(object.class.name.downcase) }
    when :vote
      _('Sorry, you may not endorse or vote for this %{object}.') % { object: _(object.class.name.downcase) }
    when :create
      _('Sorry, you may not create a %{class}.') % { class: _(object.name.downcase) }
    else
      raise ArgumentError
    end
  end
end