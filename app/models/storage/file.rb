class Storage::File < ActiveRecord::Base
  self.table_name = 'storage_files'
  attr_accessible :metadata, :accessed_at

  has_many :chunks, class_name: 'Storage::Chunk', autosave: true, dependent: :delete_all

  serialize :metadata
  validates_presence_of :metadata
  default_value_for(:metadata) { Hash.new }
  default_value_for(:accessed_at) { Time.current }

  MaxChunkSize = 256_000


  def data=(data)
    compressed_data = Zlib::Deflate.deflate(data)
    self.chunks.each(&:mark_for_destruction)
    (compressed_data.length / MaxChunkSize + 1).times do |index|
      chunk = compressed_data[index * MaxChunkSize, MaxChunkSize]
      self.chunks.new(data:chunk, idx:index)
    end
  end

  def data
    compressed_data = self.chunks.order(:idx).value_of(:data).join
    Zlib::Inflate.inflate(compressed_data)
  end
end
