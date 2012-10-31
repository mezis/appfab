class Vote < ActiveRecord::Base
  attr_accessible :idea, :user

  belongs_to :user
  belongs_to :subject, :polymorphic => true
end
