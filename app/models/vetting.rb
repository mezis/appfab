# encoding: UTF-8
class Vetting < ActiveRecord::Base
  # attr_accessible :user, :idea

  belongs_to :user
  belongs_to :idea
  include Notification::Base::CanBeSubject  
  include Traits::RecentCreation  

  validates_presence_of :user
  validates_presence_of :idea

  validates_uniqueness_of :user_id, scope: :idea_id

  scope :idea_is, lambda { |idea| where(idea_id: idea.id) }

  after_create { |record| IdeaStateMachineService.new(record.idea).trigger!(:vet›) }
  after_create { |record| record.idea.andand.ping! }
end
