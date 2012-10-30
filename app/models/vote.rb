class Vote < ActiveRecord::Base
  attr_accessible :idea_id, :user_id
end
