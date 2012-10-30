class Account < ActiveRecord::Base
  attr_accessible :name

  has_many :users

  validates_presence_of :name
end
