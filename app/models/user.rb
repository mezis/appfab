# encoding: UTF-8

class User < ActiveRecord::Base
  extend Forwardable

  # attr_accessible :karma, :account, :voting_power, :login_attributes, :login

  belongs_to :login,   inverse_of: :users
  belongs_to :account, inverse_of: :users

  has_many :ideas, :foreign_key => :author_id, :dependent => :destroy
  has_many :vettings, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :comments, :foreign_key => :author_id, :dependent => :destroy
  has_many :ideas_as_product_manager, :class_name => 'Idea', :foreign_key => :product_manager_id
  has_many :vetted_ideas, :class_name => 'Idea', :through => :vettings, :source => :idea

  include User::Role::UserMethods
  include Notification::Base::CanBeSubject
  include Notification::Base::Recipient
  include User::Bookmark::UserMethods
  include Traits::LastSeenAt
  include Traits::User::StateMachine

  validates_presence_of :login
  validates_presence_of :account
  validates_presence_of :karma
  validates_uniqueness_of :account_id, :scope => :login_id

  default_values karma: §.karma.initial,
                 voting_power: 1

  delegate [:first_name, :last_name, :email, :gravatar_url] => :login

  scope :excluding, lambda { |*users| where('users.id NOT IN (?)', users.flatten.map(&:id)) }
  scope :excluding_ids, lambda { |*ids| where('users.id NOT IN (?)', ids.flatten.uniq) }
  scope :first_name_is, lambda { |name| joins(:login).where('logins.first_name = ?', name) }
  scope :by_first_name, -> { joins(:login).order(:first_name) }
  scope :receives_digest, -> { where(receives_digest: true) }

  # this is not implemented as an association, since polymorphism and has_many through do not play well together
  def backed_ideas
    Idea.unscoped.backed_by(self)
  end


  def change_karma!(options = {})
    options[:by] or raise AttributeError.new('passing by: is mandatory')
    self.transaction do
      self.reload
      self.karma += options[:by]
      self.save!
    end
  end
end
