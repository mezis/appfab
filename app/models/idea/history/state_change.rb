class Idea::History::StateChange < Idea::History::Base
  # attr_accessible :idea, :old_state, :new_state

  validates_presence_of :old_state, :new_state

  store :payload, accessors:%i(old_state new_state)

  module Recorder
    extend ActiveSupport::Concern

    included do
      after_update :record_state_change!, if: :state_change
    end

    def record_state_change!
      old_state,new_state = state_change
      Idea::History::StateChange.create!(idea:self, old_state:old_state, new_state:new_state)
    end
  end
end
