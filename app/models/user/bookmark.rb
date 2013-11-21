class User::Bookmark < ActiveRecord::Base
  self.table_name = 'user_bookmarks'

  # attr_accessible :idea, :user
  belongs_to :user
  belongs_to :idea

  validates_uniqueness_of :user_id, :scope => :idea_id

  scope :idea_is, lambda { |idea| where(:idea_id => idea.id) }

  after_create  :ping_idea
  after_destroy :ping_idea

  module UserMethods
    def self.included(by)
      by.class_eval do
        has_many :bookmarks, :class_name => 'User::Bookmark', :dependent => :destroy
        has_many :bookmarked_ideas, :class_name => 'Idea', :through => :bookmarks, :source => :idea, :extend => AssociationMethods
      end
    end
  end

  module AssociationMethods
    def add!(idea)
      user = proxy_association.owner
      user.bookmarks.transaction do
        user.bookmarks.where(idea_id: idea.id).any? and return
        user.bookmarks.create!(idea: idea)
      end
    end

    def remove!(idea)
      user = proxy_association.owner
      user.bookmarks.transaction do
        user.bookmarks.where(idea_id: idea.id).destroy_all
      end
    end
  end

  private

  def ping_idea
    idea.ping!
  end
end
