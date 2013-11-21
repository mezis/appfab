# encoding: UTF-8
class Notification::Base < ActiveRecord::Base
  self.table_name = 'notifications'

  # attr_accessible :recipient, :subject, :body, :unread

  belongs_to :recipient, :class_name => 'User'
  belongs_to :subject, :polymorphic => true

  validates_presence_of :recipient
  validates_presence_of :subject
  
  default_values unread: true

  scope :of_type, lambda { |type_symbol| 
    where(type: (Notification.const_get type_symbol.to_s.camelize))
  }

  scope :unread, where(unread:true)
  scope :by_most_recent, order('created_at DESC')

  # makes sure all subclasses render through the "main" partial
  def to_partial_path
    'notifications/notification'
  end 

  def partial_name
    # pluralize the first component
    self.class.name.underscore.sub(%r(/),'s/')
  end


  module Recipient
    def self.included(by)
      by.class_eval do
        has_many :notifications, :foreign_key => :recipient_id, :class_name => 'Notification::Base', :dependent => :destroy, :extend => AssociationMethods
      end
    end

    module AssociationMethods
      def read!
        update_all(unread:false)
      end
    end
  end

  module CanBeSubject
    def self.included(by)
      by.class_eval do
        has_many :notifications_as_subject, :class_name => 'Notification::Base', :as => :subject, :dependent => :destroy
        has_many :notified_users, :through => :notifications_as_subject, :source => :recipient
      end
    end
  end
end
