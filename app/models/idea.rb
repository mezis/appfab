# encoding: UTF-8
class Idea < ActiveRecord::Base
  attr_accessible :title, :problem, :solution, :metrics, :deadline, :author_id, :design_size, :development_size, :rating, :state, :category, :product_manager, :kind

  ImmutableAfterVetting = %w(title problem solution metrics design_size development_size category)

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
    state :submitted
    state :vetted
    state :picked
    state :designed
    state :approved
    state :implemented
    state :signed_off
    state :live

    event :vet» do
      transition :submitted => :vetted, :if => :enough_vettings?
      transition :submitted => same
    end

    event :vote» do
      transition :vetted => same
    end

    event :veto» do
      transition [:vetted, :picked, :designed] => :submitted do
        self.vettings.destroy_all
        self.votes.destroy_all
      end
    end

    event :pick» do
      transition :vetted => :picked, :if => :enough_design_capacity?
    end

    event :design» do
      transition :picked => :designed
    end

    event :approve» do
      transition :designed => :approved, :if => :enough_development_capacity?
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

    state all - [:submitted, :vetted] do
      validates_presence_of :product_manager
    end
  end


  def participants
    User.where id:
      (self.votes.value_of(:user_id) +
      self.vettings.value_of(:user_id) +
      self.comments.value_of(:author_id) +
      [self.author.id]).uniq
  end


  private

  def sized?
    design_size.present? && development_size.present?
  end

  def enough_vettings?
    (vettings.count == configatron.socialp.vettings_needed)
  end


  def enough_design_capacity?
    configatron.socialp.design_capacity >=
      Idea.with_state(:picked).managed_by(self.product_manager).sum(:design_size) +
      self.design_size
  end


  def enough_development_capacity?
    configatron.socialp.design_capacity >=
      Idea.with_state(:approved).managed_by(self.product_manager).sum(:development_size) +
      self.development_size
  end


  def content_must_not_change
    return unless (changes.keys & ImmutableAfterVetting).any?
    errors.add :base, _('Idea statement cannot be changed once it is vetted')
  end

end
