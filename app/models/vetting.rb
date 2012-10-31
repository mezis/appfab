class Vetting < ActiveRecord::Base
  attr_accessible :user, :idea

  belongs_to :user
  belongs_to :idea

  validates_presence_of :user
  validates_presence_of :idea
end
