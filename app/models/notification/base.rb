class Notification::Base < ActiveRecord::Base
  self.table_name = 'notifications'

  attr_accessible :recipient, :subject, :body, :unread

  belongs_to :recipient, :class_name => 'User'
  belongs_to :subject, :polymorphic => true

  validates_presence_of :recipient
  validates_presence_of :subject
  
  default_values unread: true

  module CanBeSubject
    def self.included(by)
      by.class_eval do
        has_many :notifications_as_subject, :class_name => 'Notification::Base', :as => :subject, :dependent => :nullify
      end
    end
  end
end
