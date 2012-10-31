# encoding: UTF-8
class Idea < ActiveRecord::Base
  attr_accessible :title, :problem, :solution, :metrics, :deadline, :author_id, :design_size, :development_size, :rating, :state, :category

  belongs_to :author, :class_name => 'User'
  has_one    :account, :through => :author
  has_many   :vettings
  has_many   :votes, :as => :subject

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

end
