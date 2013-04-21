module AuthorizationHelper
  def not_authorized_message(action, object)
    case action
    when :update, :vet, :destroy, :edit, :pick
      _('Sorry, you may not %{verb} this %{object}.') % { verb: action, object: _(object.class.name.downcase) }
    when :vote
      _('Sorry, you may not vote for this %{object}.') % { object: _(object.class.name.downcase) }
    when :create, :new
      _('Sorry, you may not create %{class}.') % { class: _(object.name.downcase.pluralize) }
    else
      require 'pry' ; require 'pry-nav' ; binding.pry
      raise ArgumentError
    end
  end
end