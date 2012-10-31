class UserRole < ActiveRecord::Base
  Names = %w(product_manager architect developer benevolent_dictator account_owner)

  attr_accessible :user, :name

  belongs_to :user
  validates_presence_of   :user
  validates_presence_of   :name
  validates_inclusion_of  :name, in: Names
  validates_uniqueness_of :name, scope: :user_id
end
