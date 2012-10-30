class Comment < ActiveRecord::Base
  attr_accessible :idea_id, :parent_id, :author_id, :rating, :body
end
