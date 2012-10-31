class Vetting < ActiveRecord::Base
  attr_accessible :author, :idea

  belongs_to :author, :class_name => 'User'
  belongs_to :idea
end
