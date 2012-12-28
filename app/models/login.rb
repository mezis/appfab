# encoding: UTF-8
require 'gravtastic'

class Login < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :token_authenticatable

  include Gravtastic
  has_gravatar :email, size: 80, filetype: :jpg, default: :identicon

  has_many :users
  has_many :accounts, through: :users

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid
  attr_accessible :first_name, :last_name

  validates_presence_of :first_name

  after_save :adopt_account

  def self.find_or_create_from_auth_hash!(auth_hash)
    Rails.logger.debug("Auth hash: #{auth_hash.inspect}")
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
    return if self.users.any?
    account = Account.where(domain:domain, auto_adopt:true).first
    return unless account
    self.users.create! account:account
  end

end
