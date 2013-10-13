require 'delegate'
require 'state_machine'

class IdeaStateMachine
  def initialize(idea)
    @idea = idea
    super()
  end

  module ClassMethods
    def state_names
      @_state_names ||= state_machine.states.map(&:name)
    end

    def state_value(state_name)
      state_name = state_name.to_sym if state_name.kind_of?(String)
      state_machine.states[state_name].value
    end

    def state_values(*state_names)
      state_names.map { |s| state_value(s) }
    end

    def all_state_values
      @_all_state_values ||= state_machine.states.map(&:value)
    end

    def state_name(state_value)
      state_machine.states.find { |s| s.value == state_value }.name
    end

    def all_state_names
      @_all_state_names ||= state_machine.states.sort_by(&:value).map(&:name)
    end
  end
  extend ClassMethods


  private

  attr_reader :idea
  # FIXME: decouple state= to avoid dependency inversion.
  # the IdeaStateMachineService should write the state back to the idea as needed
  delegate :state, :state=, :sized?, to: :idea


  state_machine :state, :initial => :submitted do
    state :draft,        value: -1
    state :submitted,    value: 0
    state :vetted,       value: 1
    state :voted,        value: 2
    state :picked,       value: 3
    state :designed,     value: 4
    state :approved,     value: 5
    state :implemented,  value: 6
    state :signed_off,   value: 7
    state :live,         value: 8

    event :submit› do
      transition :draft => :submitted
    end

    event :vet› do
      transition :submitted => :vetted, :if => :_can_become_vetted?
      transition :submitted => same
    end

    event :vote› do
      transition :vetted => :voted,  :if     => :_enough_votes?
      transition :voted  => :vetted, :unless => :_enough_votes?
      transition [:vetted, :voted] => same
    end

    event :abort› do
      transition (any - [:draft, :submitted, :live]) => :submitted
    end

    event :pick› do
      transition [:vetted, :voted] => :picked, :if => :sized?
    end

    event :design› do
      transition :picked => :designed
    end

    event :approve› do
      transition :designed => :approved
    end
    
    event :implement› do
      transition :approved => :implemented
    end
    
    event :sign_off› do
      transition :implemented => :signed_off
    end
    
    event :deliver› do
      transition :signed_off => :live
    end

    # 
    # transition hooks
    # 
    after_transition :on => :abort›, :do => :_remove_vettings_and_votes!
  end


  def _can_become_vetted?
    idea.design_size && idea.development_size && (idea.vettings.count >= §.vettings_needed)
  end


  def _enough_votes?
    (idea.votes.count >= §.votes_needed)
  end

  def _remove_vettings_and_votes!
    idea.vettings.destroy_all
    idea.votes.destroy_all
  end

end
