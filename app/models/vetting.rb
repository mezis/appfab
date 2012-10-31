class Vetting < ActiveRecord::Base
  attr_accessible :user, :idea

  belongs_to :user
  belongs_to :idea
end
