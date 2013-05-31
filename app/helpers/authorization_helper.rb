module AuthorizationHelper
  def not_authorized_message(action, object)
    case action
    when :update, :vet, :destroy, :edit, :pick
      _('Sorry, you may not %{verb} this %{object}.') % { verb: action, object: _(object.class.name.downcase) }
    when :update_admin
      _('Sorry, you may not %{verb} this %{object}.') % { verb: 'update', object: _(object.class.name.downcase) }
    when :vote
      ( object.kind_of?(Idea) ?
        _('Sorry, you may not endorse this %{object}.') :
        _('Sorry, you may not vote for this %{object}.')
      ) % { object: _(object.class.name.downcase) }
    when :create, :new
      _('Sorry, you may not create %{class}.') % { class: _(object.name.downcase.pluralize) }
    else
      raise ArgumentError
      raise ArgumentError, 'unknown action'
    end
  end
end