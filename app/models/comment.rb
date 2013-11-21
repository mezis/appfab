# encoding: UTF-8
class Comment < ActiveRecord::Base
  # attr_accessible :idea, :parent, :author, :rating, :body
  # attr_accessible :idea_id, :parent_id

  belongs_to :idea, :counter_cache => true
  belongs_to :author, :class_name => 'User'
  has_many   :votes, :as => :subject, :dependent => :destroy
  has_many   :attachments, :class_name => 'Attachment', :as => :owner, :dependent => :destroy

  include Notification::Base::CanBeSubject  
  include Traits::RecentCreation  
  include Idea::History::Comment::IsSubject

  default_values rating: 0

  validates_presence_of :author
  validates_presence_of :idea
  validates_presence_of :body, message:_('Blank comments are not permitted.')
  validates_presence_of :rating

  scope :by_created_at, -> { order('created_at DESC') }

  after_create { |record| record.idea.andand.ping! }
end
