# encoding: UTF-8
# encoding: UTF-8
class Vote < ActiveRecord::Base
  attr_accessible :subject, :user, :up

  belongs_to :user
  belongs_to :subject, :polymorphic => true

  validates_presence_of :user
  validates_presence_of :subject
  validates_inclusion_of :up, in: [true, false]
  validates_uniqueness_of :user_id, scope: [:subject_id, :subject_type]

  default_values up: true

  scope :on_idea, lambda { |*ideas| where(subject_type:'Idea', subject_id:ideas)}

  after_create  :notify_idea
  after_destroy :notify_idea

  def up?
    self.up
  end

  def down?
    !self.up
  end


  private


  def notify_idea
    subject.vote» if subject.respond_to?(:vote»)
  end
end
