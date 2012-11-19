class RenameDataToEncodedDataInStorageChunks < ActiveRecord::Migration
  def up
    rename_column :storage_chunks, :data, :encoded_data
  end

  def down
    rename_column :storage_chunks, :encoded_data, :data
  end
end
