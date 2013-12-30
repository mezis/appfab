# Form object to allow user mutation without resorting to
# +accepts_nested_attributes_for+
# 
# Inspired from
# - http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
# - http://pivotallabs.com/form-backing-objects-for-fun-and-profit/

class User::EditForm
  include Virtus.model
  extend Forwardable
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :first_name,    String
  attribute :last_name,     String
  attribute :voting_power,  Fixnum
  attribute :state,         Fixnum

  attr_reader :user, :login

  # Forms are never themselves persisted, but this only exists for existing users
  delegate [:id, :persisted?] => :user


  def initialize(user)
    raise ArgumentError if user.nil?

    @user  = user
    @login = user.login

    self.voting_power = user.voting_power
    self.state        = user.state
    self.first_name   = login.first_name
    self.last_name    = login.last_name
  end


  def update_attributes(params = nil)
    params ||= {}
    params = params.to_hash.to_options
    raise ArgumentError if (params.keys - attributes.keys).any?
    self.attributes = attributes.merge(params)

    user.voting_power = attributes[:voting_power]
    user.state        = attributes[:state]
    login.first_name  = attributes[:first_name]
    login.last_name   = attributes[:last_name]

    return false unless valid?
    persist!
    true
  end


  def needs_admin_rights?(params = nil)
    params ||= {}
    (params.has_key?(:voting_power) && params[:voting_power] != attributes[:voting_power]) ||
    (params.has_key?(:state)        && params[:state]        != attributes[:state]       )
  end


  def save
    update_attributes
  end


  def self.model_name
    User.model_name
  end


private


  # bubble up errors form individual models
  validate do
    [user, login].each do |record|
      next if record.valid?
      record.errors.each { |key,value| errors[key] = value }
      errors[:base] << _('%{model} invalid') % { model:record.class.model_name.human }
    end
  end

  def persist!
    user.transaction do
      user.save!
      login.save!
    end
  end

end
