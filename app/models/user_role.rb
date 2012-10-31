class UserRole < ActiveRecord::Base
  Names = [:product_manager, :architect, :developer, :benevolent_dictator, :account_owner]

  attr_accessible :user, :name, :user_id

  belongs_to :user
  validates_presence_of   :user
  validates_presence_of   :name
  validates_inclusion_of  :name, in: Names
  validates_uniqueness_of :name, scope: :user_id

  # User methods, defined here to separate concerns
  module UserMethods
    def self.included(by)
      by.class_eval do
        has_many :roles, class_name: 'UserRole'

        scope :playing, lambda { |*role_names|
          joins(:roles).where('user_roles.name' => role_names)
        }
      end
    end

    def plays!(role_name)
      self.roles.transaction do
        return if plays?(role_name)
        self.roles.create!(name: role_name)
      end
      return self
    end

    def plays?(role_name)
      role_name = role_name.to_sym if role_name.kind_of?(String)
      Names.include?(role_name) or
        raise ArgumentError.new("Unknown role '#{role_name}'")
      return self.roles.where(name: role_name).any?
    end
  end

  private

  before_validation do |record|
    record.name = record.name.to_sym if record.name.kind_of?(String)
  end

end
