# encoding: UTF-8
class User::Role < ActiveRecord::Base
  Names = [:product_manager, :architect, :developer, :designer, :benevolent_dictator, :account_owner]

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
        has_many :roles, class_name: 'User::Role', :dependent => :destroy

        scope :playing, lambda { |*role_names|
          joins(:roles).where('user_roles.name' => role_names).group('users.id')
        }
      end
    end

    def plays!(*role_names)
      self.roles.transaction do
        role_names.uniq.each do |role_name|
          next if plays?(role_name)
          self.roles.create!(name: role_name)
        end
      end
      @cached_roles = nil
      return self
    end

    def plays?(*role_names)
      role_names = role_names.map { |name| name.kind_of?(String) ? name.to_sym : name }
      (role_names - Names).empty? or
        raise ArgumentError.new("Unknown roles in arguments")
      return cached_roles.find { |role| role_names.include?(role.name.to_sym) }
    end

    protected

    def cached_roles
      @cached_roles ||= self.roles.all
    end
  end

  private

  before_validation do |record|
    record.name = record.name.to_sym if record.name.kind_of?(String)
  end

end
