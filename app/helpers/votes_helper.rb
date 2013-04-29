module VotesHelper

  def votes_message(record, action)
    if record.subject.kind_of?(Idea)
      case action
        when :ok     then _('You have endorsed the idea.')
        when :fail   then _('Failed to endorse the idea.')
        when :cancel then _('Endorsement withdrawn')
        else raise ArgumentError
      end
    elsif record.subject.kind_of?(Comment) 
      case action
        when :ok     then record.up ? _('You have upvoted the comment.') : _('You have dowvoted the comment.')
        when :fail   then _('Failed to vote on the comment.')
        when :cancel then _('Canceled your vote on the comment.')
        else raise ArgumentError
      end
    else
      raise ArgumentError
    end
  end

end