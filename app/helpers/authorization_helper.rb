module AuthorizationHelper
  def not_authorized_message(action, object)
    case action
    when :update
      _('Sorry, you may not update this %{object}') % { object: _(object.class.name.downcase) }
    end
  end
end