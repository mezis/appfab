class Vote < ActiveRecord::Base
  attr_accessible :idea_id, :user_id

  belongs_to :user
  belongs_to :idea
end
