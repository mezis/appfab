class Comment < ActiveRecord::Base
  attr_accessible :idea, :parent, :author, :rating, :body

  belongs_to :idea
  belongs_to :parent,   :class_name => 'Comment'
  has_many   :children, :class_name => 'Comment', :foreign_key => :parent_id,
                        :dependent => :destroy
  belongs_to :author,   :class_name => 'User'
  has_many   :votes, :as => :subject, :dependent => :destroy

  default_values rating: 0

  validates_presence_of :author
  validates_presence_of :idea
  validates_presence_of :body
  validates_presence_of :rating
end
