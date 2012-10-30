class Idea < ActiveRecord::Base
  attr_accessible :title, :problem, :solution, :metrics, :deadline, :author_id, :design_size, :development_size, :rating, :state, :category

  belongs_to :author, :class_name => 'User'
  has_many   :votes
end
