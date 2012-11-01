class Attachment < ActiveRecord::Base
  attr_accessible :mime_type, :name, :owner, :uploader, :file

  belongs_to :owner, :polymorphic => true
  belongs_to :uploader, :class_name => 'User'

  file_accessor :file

  validates_presence_of :owner
  validates_presence_of :uploader
  validates_presence_of :file
end
