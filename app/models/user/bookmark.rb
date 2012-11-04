class User::Bookmark < ActiveRecord::Base
  self.table_name = 'user_bookmarks'

  attr_accessible :idea, :user
  belongs_to :user
  belongs_to :idea

  validates_uniqueness_of :idea_id, :scope => :user_id

  scope :idea_is, lambda { |idea| where(:idea_id => idea.id) }
end
