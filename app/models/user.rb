# encoding: UTF-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :token_authenticatable

  include Gravtastic
  has_gravatar :email, size: 80, filetype: :png, default: :identicon

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid
  attr_accessible :first_name, :last_name, :role, :karma, :account, :voting_power

  belongs_to :account
  has_many :ideas, :foreign_key => :author_id, :dependent => :destroy
  has_many :vettings, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :comments, :foreign_key => :author_id, :dependent => :destroy
  has_many :notifications, :foreign_key => :recipient_id, :class_name => 'Notification::Base', :dependent => :destroy
  has_many :ideas_as_product_manager, :class_name => 'Idea', :foreign_key => :product_manager_id
  has_many :vetted_ideas, :class_name => 'Idea', :through => :vettings, :source => :idea
  has_many :backed_ideas, :class_name => 'Idea', :through => :votes, :source => :idea

  include UserRole::UserMethods
  include Notification::Base::CanBeSubject
  include User::Bookmark::UserMethods

  validates_presence_of :first_name
  validates_presence_of :karma

  default_values karma: configatron.app_fab.karma.initial,
                 voting_power: 1

  before_validation :adopt_account

  scope :excluding, lambda { |*users| where('users.id NOT IN (?)', users.flatten.map(&:id)) }

  def self.find_or_create_from_auth_hash!(auth_hash)
    user = self.where(uid: auth_hash[:uid], provider: auth_hash[:provider]).first and return user

    self.new.tap do |user|
      if auth_hash[:info][:first_name]
        user.first_name = auth_hash[:info][:first_name]
        user.last_name  = auth_hash[:info][:last_name]
      elsif auth_hash[:info][:name] =~ /(.*?)\s+(.*)/
        user.first_name = $1.andand.strip
        user.last_name  = $2.andand.strip
      else
        user.first_name = auth_hash[:info][:name].strip
      end

      user.email    = auth_hash[:info][:email]
      user.provider = auth_hash[:provider]
      user.uid      = auth_hash[:uid]
      user.password = SecureRandom.base64
      user.save!
    end
  end


  def change_karma!(options = {})
    options[:by] or raise AttributeError.new('passing by: is mandatory')
    self.transaction do
      self.reload
      self.karma += options[:by]
      self.save!
    end
  end


  def login
    "@#{first_name}#{last_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end


  private

  EmailDomainRE = /@(?<domain>.*)$/

  def domain
    EmailDomainRE.match(self.email).andand[:domain]
  end

  def adopt_account
    return if domain.nil?
    return if self.account
    self.account = Account.where(domain:domain, auto_adopt:true).first
  end

end
