class Storage::Chunk < ActiveRecord::Base
  self.table_name = 'storage_chunks'
  # attr_accessible :data, :idx

  belongs_to :file, class_name: 'Storage::File'

  validates_presence_of :file
  validates_presence_of :encoded_data

  def data=(raw_data)
    compressed_data = Zlib::Deflate.deflate(raw_data)
    self.encoded_data = Base64.encode64(compressed_data)
  end

  def data
    Zlib::Inflate.inflate Base64.decode64(self.encoded_data)
  end  
end
