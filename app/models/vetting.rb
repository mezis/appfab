# encoding: UTF-8
class Vetting < ActiveRecord::Base
  attr_accessible :user, :idea

  belongs_to :user
  belongs_to :idea

  include Notification::Base::CanBeSubject  

  validates_presence_of :user
  validates_presence_of :idea

  validates_uniqueness_of :user_id, scope: :idea_id

  validate :idea_must_be_sized

  scope :idea_is, lambda { |idea| where(idea_id: idea.id) }

  after_create { |record| record.idea.andand.vet» }

  private

  def idea_must_be_sized
    return unless user && idea
    if user.plays?(:architect) && idea.development_size.nil?
      errors.add :base, _('Idea lacks development sizing')
    end
    if user.plays?(:product_manager) && idea.design_size.nil?
      errors.add :base, _('Idea lacks design sizing')
    end
  end

end
