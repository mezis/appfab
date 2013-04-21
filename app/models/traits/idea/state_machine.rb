# encoding: UTF-8
require 'state_machine'

module Traits::Idea::StateMachine
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
    attr_accessible :state
    setup_state_machine
    after_update :try_to_vet!
  end

  def all_states
    @@all_states ||= self.class.state_machine.states.map(&:name)
  end

  def can_become_vetted?
    design_size && development_size && (vettings.count >= configatron.app_fab.vettings_needed)
  end


  def enough_votes?
    (votes.count >= configatron.app_fab.votes_needed)
  end


  def enough_design_capacity?
    return if configatron.app_fab.design_capacity >=
      Idea.with_state(:picked).managed_by(self.product_manager).sum(:design_size) +
      self.design_size
    errors.add :base, _('Not enough design capacity')
  end


  def enough_development_capacity?
    return if configatron.app_fab.design_capacity >=
      Idea.with_state(:approved).managed_by(self.product_manager).sum(:development_size) +
      self.development_size
    errors.add :base, _('Not enough development capacity')
  end


  def content_must_not_change
    return unless (changes.keys & ImmutableAfterVetting).any?
    errors.add :base, _('Idea statement cannot be changed once it is vetted')
  end

  def is_state_in_future?(state)
    state = state.to_sym if state.kind_of?(String)
    all_states.index(self.state_name) < all_states.index(state)
  end

  def try_to_vet!
    return unless submitted? && can_become_vetted?
    vet»
  end


  module ClassMethods
    def state_value(state_name)
      state_name = state_name.to_sym if state_name.kind_of?(String)
      self.state_machine.states[state_name].value
    end

    def state_name(state_value)
      self.state_machine.states.find { |state| state.value == state_value }.name
    end

    private

    def setup_state_machine
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

        event :submit» do
          transition :draft => :submitted
        end

        event :vet» do
          transition :submitted => :vetted, :if => :can_become_vetted?
          transition :submitted => same
        end

        event :vote» do
          transition :vetted => :voted,  :if => :enough_votes?
          transition :voted  => :vetted, :unless => :enough_votes?
          transition [:vetted, :voted] => same
        end

        event :veto» do
          transition [:vetted, :voted, :picked, :designed] => :submitted do
            self.vettings.destroy_all
            self.votes.destroy_all
          end
        end

        event :pick» do
          transition :voted => :picked
        end

        event :design» do
          transition :picked => :designed
        end

        event :approve» do
          transition :designed => :approved
        end

        event :implement» do
          transition :approved => :implemented
        end

        event :sign_off» do
          transition :implemented => :signed_off
        end

        event :deliver» do
          transition :signed_off => :live
        end

        state all - [:draft] do
          validates_presence_of :problem, :solution, :metrics
        end

        # state-specific validations
        state all - [:draft, :submitted] do
          validate :content_must_not_change
          validates_presence_of :design_size
          validates_presence_of :development_size
        end

        state all - [:draft, :submitted, :vetted, :voted] do
          validates_presence_of :product_manager
        end
      end
    end
  end

end