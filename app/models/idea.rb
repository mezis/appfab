# encoding: UTF-8
class Idea < ActiveRecord::Base
  attr_accessible :title, :problem, :solution, :metrics, :deadline, :author, :design_size, :development_size, :rating, :state, :category, :product_manager, :kind, :active_at

  ImmutableAfterVetting = %w(title problem solution metrics design_size development_size category)
  StatesForWizard = [
    N_('Ideas State|submitted'),
    N_('Ideas State|vetted'),
    N_('Ideas State|voted'),
    N_('Ideas State|picked'),
    N_('Ideas State|designed'),
    N_('Ideas State|approved'),
    N_('Ideas State|implemented'),
    N_('Ideas State|signed_off'),
    N_('Ideas State|live')
  ]

  belongs_to :author, :class_name => 'User'
  has_one    :account, :through => :author
  has_many   :vettings, :dependent => :destroy
  has_many   :votes, :as => :subject, :dependent => :destroy
  has_many   :comments
  has_many   :toplevel_comments, :class_name => 'Comment', :as => :parent
  has_many   :attachments, :class_name => 'Attachment', :as => :owner, :dependent => :destroy
  belongs_to :product_manager, :class_name => 'User'

  has_many   :vetters, :class_name => 'User', :through => :vettings, :source => :user
  has_many   :backers, :class_name => 'User', :through => :votes,    :source => :user
  has_many   :bookmarks,   :class_name => 'User::Bookmark', :dependent => :destroy


  validates_presence_of :rating
  # validates_presence_of :category

  validates_presence_of :title, :problem, :solution, :metrics
  validates_inclusion_of :deadline,
    allow_nil: true,
    in: Proc.new { Date.today .. (Date.today + 365) }

  validates_inclusion_of :design_size,      :in => 1..4, :allow_nil => true
  validates_inclusion_of :development_size, :in => 1..4, :allow_nil => true

  validates_presence_of  :kind
  validates_inclusion_of :kind, :in => %w(bug chore feature)

  default_values rating: 0, kind:'feature'


  scope :managed_by, lambda { |user| where(product_manager_id: user) }


  state_machine :state, :initial => :submitted do
    state :submitted,    value: 0
    state :vetted,       value: 1
    state :voted,        value: 2
    state :picked,       value: 3
    state :designed,     value: 4
    state :approved,     value: 5
    state :implemented,  value: 6
    state :signed_off,   value: 7
    state :live,         value: 8

    event :vet» do
      transition :submitted => :vetted, :if => :enough_vettings?
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

    # state-specific validations
    state all - [:submitted] do
      validate :content_must_not_change
      validates_presence_of :design_size
      validates_presence_of :development_size
    end

    state all - [:submitted, :vetted, :voted] do
      validates_presence_of :product_manager
    end

    state :picked do
      validate :enough_design_capacity?
    end

    state :approved do
      validate :enough_development_capacity?
    end
  end


  # Other helpers


  def participants
    User.where id:
      (self.votes.value_of(:user_id) +
      self.vettings.value_of(:user_id) +
      self.comments.value_of(:author_id) +
      [self.author.id]).uniq
  end


  def sized?
    design_size.present? && development_size.present?
  end

  def size
    sized? and [design_size, development_size].max
  end


  # Search angles
  
  def self.discussable_by(user)
    user.account ? user.account.ideas : user.ideas
  end

  def self.vettable_by(user)
    discussable_by(user).with_state('submitted')
  end

  def self.votable_by(user)
    discussable_by(user).with_state('vetted', 'voted')
  end

  def self.buildable_by(user)
    discussable_by(user).with_state('picked', 'designed', 'approved', 'implemented', 'signed_off')
  end

  def self.followed_by(user)
    user.bookmarked_ideas
  end


  # Search orders


  def self.by_rating
    order('ideas.rating DESC')
  end

  def self.by_activity
    order('ideas.active_at DESC')
  end

  def self.by_progress
    order('ideas.state DESC')
  end

  def self.by_creation
    order('ideas.created_at DESC')
  end


  # Search filters

  def self.authored_by(user)
    where(author_id: user.id)
  end

  def self.commented_by(user)
    joins(:comments).where('comments.author_id = ?', user.id).group('ideas.id')
  end

  def self.vetted_by(user)
    joins(:vettings).where('vettings.user_id = ?', user.id).group('ideas.id')
  end

  def self.backed_by(user)
    joins(:votes).where('votes.user_id = ?', user.id).group('ideas.id')
  end


  # called from subresources (comments, vettings, votes)
  def ping!
    update_attributes! active_at: Time.now
  end


  def is_state_in_future?(state)
    state = state.to_sym if state.kind_of?(String)
    all_states.index(self.state_name) < all_states.index(state)
  end




  private


  before_save do |record|
    unless record.updated_at.nil?
      record.active_at = record.updated_at if record.active_at.nil? || record.updated_at > record.active_at
    end
  end



  def all_states
    @@all_states ||= self.class.state_machine.states.map(&:name)
  end

  def enough_vettings?
    (vettings.count >= configatron.app_fab.vettings_needed)
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

end
