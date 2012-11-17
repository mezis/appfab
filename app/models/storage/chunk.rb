class Storage::Chunk < ActiveRecord::Base
  self.table_name = 'storage_chunks'
  attr_accessible :data, :idx

  belongs_to :file, class_name: 'Storage::File'

  validates_presence_of :file
end
