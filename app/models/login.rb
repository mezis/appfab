# encoding: UTF-8
class Login < ActiveRecord::Base
  include Traits::HasAvatar
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :rememberable, 
    :trackable, :validatable,
    :omniauthable

  has_many :users, dependent: :destroy
  has_many :accounts, through: :users

  # attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :provider, :uid
  # attr_accessible :first_name, :last_name

  validates_presence_of :first_name

  serialize :auth_provider_data

  def login
    "@#{first_name}#{last_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def auth_provider_data
    super || (self.auth_provider_data = {})
  end
end
