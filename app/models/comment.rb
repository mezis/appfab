class Comment < ActiveRecord::Base
  attr_accessible :idea_id, :parent_id, :author_id, :rating, :body

  belongs_to :idea
  belongs_to :parent,   :class_name => 'Comment'
  has_many   :children, :class_name => 'Comment', :as => :parent
  belongs_to :author,   :class_name => 'User'

  defaults rating: 0
end
