class Vote < ActiveRecord::Base
  attr_accessible :idea, :user, :up

  belongs_to :user
  belongs_to :subject, :polymorphic => true

  validates_inclusion_of :up, in: [true, false]

  def up?
    self.up
  end

  def down?
    !self.up
  end
end
