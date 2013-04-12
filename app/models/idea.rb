# encoding: UTF-8
require 'lazy_records'

class Idea < ActiveRecord::Base
  attr_accessible :title, :problem, :solution, :metrics, :deadline, :author, :design_size, :development_size, :rating, :category, :product_manager, :active_at

  belongs_to :author, :class_name => 'User'
  belongs_to :account
  has_many   :vettings, :dependent => :destroy
  has_many   :votes, :as => :subject, :dependent => :destroy
  has_many   :comments, :dependent => :destroy
  has_many   :attachments, :class_name => 'Attachment', :as => :owner, :dependent => :destroy
  belongs_to :product_manager, :class_name => 'User'

  include Notification::Base::CanBeSubject  
  include Traits::Idea::StateMachine
  include LazyRecords::Model
  include Idea::History::Base::HasHistory
  include Idea::History::Creation::Recorder
  include Idea::History::StateChange::Recorder

  has_many   :commenters, :class_name => 'User', :through => :comments, :source => :author
  has_many   :vetters,    :class_name => 'User', :through => :vettings, :source => :user
  has_many   :backers,    :class_name => 'User', :through => :votes,    :source => :user
  has_many   :bookmarks,  :class_name => 'User::Bookmark', :dependent => :destroy
  has_many   :bookmarkers, :through => :bookmarks, :source => :idea

  validates_presence_of  :author
  validates_presence_of  :account
  validates_presence_of  :rating
  validates_presence_of  :title
  validates_inclusion_of :design_size,      :in => 1..4, :allow_nil => true
  validates_inclusion_of :development_size, :in => 1..4, :allow_nil => true
  validates_inclusion_of :category, in: lambda { |idea| idea.account.categories }, allow_nil:true

  default_values rating: 0

  before_save :update_active_at

  scope :managed_by, lambda { |user| where(product_manager_id: user) }
  scope :not_vetted_by,  lambda { |user| where('ideas.id NOT IN (?)', user.vetted_ideas.value_of(:id)) }
  scope :backed_by, lambda { |user| joins(:votes).where('votes.user_id = ?', user.id) }

  # Other helpers

  def participants
    ids = Rails.cache.fetch("#{self.class.name}/#{__method__}/#{id}/#{active_at.to_i}") do
      [
        self.author.id,
        self.votes.value_of(:user_id),
        self.vettings.value_of(:user_id),
        self.comments.value_of(:author_id)
      ].flatten.uniq
    end

    lazy_collection_of(User, ids:ids, includes:[:login])
  end


  def sized?
    design_size.present? && development_size.present?
  end

  def size
    sized? and [design_size, development_size].max
  end

  def backed_by?(user)
    backers.value_of(:id).include?(user.id)
  end


  # Search angles
  
  def self.discussable_by(user)
    user.account.ideas.without_state(:draft)
  end

  def self.vettable_by(user)
    discussable_by(user).with_state(:submitted)
  end

  def self.votable_by(user)
    discussable_by(user).with_state(:vetted, :voted)
  end

  def self.pickable_by(user)
    discussable_by(user).with_state(:voted)
  end

  def self.approvable_by(user)
    discussable_by(user).with_state(:designed)
  end

  def self.signoffable_by(user)
    discussable_by(user).with_state(:implemented)
  end

  def self.buildable_by(user)
    discussable_by(user).with_state(:picked, :approved, :signed_off)
  end

  def self.followed_by(user)
    user.bookmarked_ideas
  end


  # Search orders


  def self.by_rating
    order('COALESCE(1000 * ideas.rating / (ideas.development_size + ideas.design_size), -1) DESC, ideas.active_at DESC')
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
    self.class.where(id:id).update_all(active_at:Time.current)
  end


  protected

  def update_active_at
    return unless changes.any?
    self.active_at = Time.current
  end
end
