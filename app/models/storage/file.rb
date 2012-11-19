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
    self.chunks.each(&:mark_for_destruction)
    (data.length / MaxChunkSize + 1).times do |index|
      chunk = data[index * MaxChunkSize, MaxChunkSize]
      self.chunks.new(data:chunk, idx:index)
    end
  end

  def data
    self.chunks.order(:idx).map(&:data).join
  end
end
