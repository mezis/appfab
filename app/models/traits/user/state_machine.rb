require 'state_machine'

module Traits::User::StateMachine
  extend ActiveSupport::Concern

  included do
    attr_accessible :state
    validates_presence_of :state
    setup_state_machine
  end

  # FIXME: this need to be factored out to a super module
  def all_states
    @@all_states ||= self.class.state_machine.states.map(&:name)
  end

  module ClassMethods
    # FIXME: this need to be factored out to a super module
    def state_value(state_name)
      state_name = state_name.to_sym if state_name.kind_of?(String)
      self.state_machine.states[state_name].value
    end

    # FIXME: this need to be factored out to a super module
    def state_name(state_value)
      self.state_machine.states.find { |state| state.value == state_value }.name
    end

    private

    def setup_state_machine
      state_machine :state, :initial => :visible do
        state :visible,      value: 0
        state :hidden,       value: 1

        event :hide» do
          transition :visible => :hidden
        end

        event :show» do
          transition :hidden => :visible
        end
      end
    end
  end
end
