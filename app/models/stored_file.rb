class StoredFile < ActiveRecord::Base
  attr_accessible :blob, :metadata, :accessed_at

  serialize :metadata

  validates_presence_of :metadata
  validates_presence_of :blob

  default_value_for(:metadata) { Hash.new }

  class DataStore
    def store(temp_object, opts={})
      blob = Zlib::Deflate.deflate(temp_object.data)
      StoredFile.create!(blob:blob, metadata:temp_object.meta).id.to_s
    end

    def retrieve(uid)
      stored = StoredFile.find(uid.to_i)
      stored.update_attributes!(accessed_at: Time.now)
      data = Zlib::Inflate.inflate(stored.blob)
      [ data, stored.metadata ]
    end

    def destroy(uid)
      StoredFile.destroy(uid.to_i)
    end
  end
end
