# encoding: UTF-8
class Idea < ActiveRecord::Base
  attr_accessible :title, :problem, :solution, :metrics, :deadline, :author_id, :design_size, :development_size, :rating, :state, :category

  belongs_to :author, :class_name => 'User'
  has_one    :account, :through => :author
  has_many   :vettings, :dependent => :destroy
  has_many   :votes, :as => :subject, :dependent => :destroy
  has_many   :comments
  has_many   :toplevel_comments, :class_name => 'Comment', :as => :parent

  validates_presence_of :rating
  # validates_presence_of :category

  validates_presence_of :title, :problem, :solution, :metrics
  validates_inclusion_of :deadline,
    allow_nil: true,
    in: Proc.new { Date.today .. (Date.today + 365) }

  validates_inclusion_of :design_size,      :in => 0..3, :allow_nil => true
  validates_inclusion_of :development_size, :in => 0..3, :allow_nil => true

  default_values rating: 0

  state_machine :state, :initial => :submitted do
    state :submitted
    state :vetted
    state :picked
    state :designed
    state :approved
    state :implemented
    state :signed_off
    state :live

    event :vet» do
      transition :submitted => :vetted,
        :if => lambda { |idea| idea.vettings.count == configatron.socialp.vettings_needed }
      transition :submitted => same
    end

  end


  def participants
    User.where id:
      (self.votes.value_of(:user_id) +
      self.vettings.value_of(:user_id) +
      self.comments.value_of(:author_id) +
      [self.author.id]).uniq
  end

end
