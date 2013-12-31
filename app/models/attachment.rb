class Attachment < ActiveRecord::Base
  # attr_accessible :mime_type, :size, :name, :owner, :uploader, :file

  belongs_to :owner, :polymorphic => true, :counter_cache => true
  belongs_to :uploader, :class_name => 'User'

  file_accessor :file

  delegate :format, to: :file

  validates_presence_of :owner
  validates_presence_of :uploader
  validates_presence_of :file

  before_save do |record|
    record.size      = file.size
    record.mime_type = file.mime_type
    record.name      = file.name
  end
end
