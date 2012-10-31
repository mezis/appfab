class Account < ActiveRecord::Base
  attr_accessible :name, :auto_adopt, :domain

  has_many :users, :dependent => :destroy
  has_many :ideas, :through => :users

  validates_presence_of :name
  validates_presence_of :domain, if: :auto_adopt

  default_values auto_adopt:false
end
