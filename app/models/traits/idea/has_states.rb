# encoding: UTF-8
require 'state_machine'

module Traits::Idea::HasStates
  extend ActiveSupport::Concern

  ImmutableAfterVetting = %w(title problem solution metrics design_size development_size category)

  StatesForWizard = [
    N_('Ideas State|draft'),
    N_('Ideas State|submitted'),
    N_('Ideas State|vetted'),
    N_('Ideas State|endorsed'),
    N_('Ideas State|picked'),
    N_('Ideas State|designed'),
    N_('Ideas State|approved'),
    N_('Ideas State|implemented'),
    N_('Ideas State|signed_off'),
    N_('Ideas State|live')
  ]

  included do
    # attr_accessible :state

    validates_presence_of  :state
    validates_inclusion_of :state, in: IdeaStateMachine.all_state_values
    # TODO
    # validates :content_must_not_change

    before_validation :auto_vet_on_size_change

    default_values state: IdeaStateMachine.state_value(:submitted)
  end

  def state_is?(name)
    state == state_machine.state_value(name)
  end

  # auto-vet on sizing changes
  # FIXME: move to controller & state machine service.
  def auto_vet_on_size_change
    return unless design_size_changed? || development_size_changed?
    return unless state_machine.can_vet›?
    state_machine.vet›
  end


  def content_must_not_change
    return unless (changes.keys & ImmutableAfterVetting).any?
    errors.add :base, _('Idea statement cannot be changed once it is vetted')
  end

  def is_state_in_future?(state)
    self.state < IdeaStateMachine.state_value(state)
  end

  def state_machine
    @_state_machine ||= IdeaStateMachine.new(self)
  end


  # module ClassMethods

        # # 
        # # state-specific validations
        # # 
        # state all - [:draft] do
        #   validates_presence_of :problem, :solution, :metrics
        # end

        # state all - [:draft, :submitted] do
        #   validate :content_must_not_change
        #   validates_presence_of :design_size
        #   validates_presence_of :development_size
        # end

        # state all - [:draft, :submitted, :vetted, :voted] do
        #   validates_presence_of :product_manager
        # end
  # end

end
