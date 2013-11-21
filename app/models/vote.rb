# encoding: UTF-8
# encoding: UTF-8
class Vote < ActiveRecord::Base
  # attr_accessible :subject, :user, :up

  belongs_to :user
  belongs_to :subject, :polymorphic => true, :counter_cache => :votes_cache
  include Notification::Base::CanBeSubject  
  include Traits::RecentCreation  

  validates_presence_of :user
  validates_presence_of :subject
  validates_inclusion_of :up, in: [true, false]
  validates_uniqueness_of :user_id, scope: [:subject_id, :subject_type]

  default_values up: true

  scope :on_idea,   lambda { |*ideas| where(subject_type:'Idea', subject_id:ideas)}
  scope :by_user,   lambda { |user| where(user_id:user.id) }
  scope :upvote,    where(up:true)
  scope :downvote,  where(up:false)

  after_create  :notify_idea
  after_destroy :notify_idea

  def up?
    !!self.up
  end

  def down?
    !self.up
  end

  private


  def notify_idea
    return unless subject.kind_of?(Idea)
    if subject.state_machine.can_vote›?
      IdeaStateMachineService.new(subject).trigger!(:vote›)
    end
    subject.ping!
  end
end
