require 'delegate'

class IdeaStateMachineService
  def initialize(idea)
    @_idea = idea
    @_state_machine = IdeaStateMachine.new(idea)
  end

  def run
    return unless _idea.state_changed?

    state_from = IdeaStateMachine.state_name(_idea.state_was)
    state_to   = IdeaStateMachine.state_name(_idea.state)
    path = _state_machine.state_paths(from:state_from, to:state_to).min_by(&:length)
    if path.nil?
      raise RuntimeError, "invalid transition from #{idea.state_was} to #{idea.state}"
    end

    _idea.transaction do
      path.each { |transition| transition.perform }
    end
  end

  def trigger!(*events)
    _idea.transaction do
      _state_machine.fire_events!(*events)
      _idea.save!
    end
  end

  private

  attr_reader :_idea
  attr_reader :_state_machine
end