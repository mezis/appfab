class Storage::DataStore

  # +temp_object+ should respond to +data+ and +meta+
  def write(temp_object, opts={})
    ::Storage::File.transaction do
      file = ::Storage::File.create!(metadata: temp_object.meta)
      file.data = temp_object.data
      file.save!

      Rails.logger.info "created #{file.reload.chunks.count} chunks"
      return file.id.to_s
    end
  end

  def read(uid)
    file = ::Storage::File.find(uid.to_i)
    file.update_attributes!(accessed_at: Time.now)
    [ file.data, file.metadata ]
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def destroy(uid)
    ::Storage::File.destroy(uid.to_i)
  end
end
