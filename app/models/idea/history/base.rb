class Idea::History::Base < ActiveRecord::Base
  self.table_name = 'idea_histories'
  # attr_accessible :idea, :subject

  belongs_to :idea, inverse_of: :histories
  belongs_to :subject, polymorphic:true

  scope :by_created_at,  -> { order('created_at DESC') }

  validates_presence_of :idea

  module HasHistory
    extend ActiveSupport::Concern

    included do
      has_many :histories, :class_name => 'Idea::History::Base', :dependent => :destroy, inverse_of: :idea
    end
  end
end
