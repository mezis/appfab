class Idea::History::Creation < Idea::History::Base

  module Recorder
    extend ActiveSupport::Concern

    included do
      after_create :record_creation!
    end

    def record_creation!
      Idea::History::Creation.create!(idea:self)
    end
  end
end
