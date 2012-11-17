class CreateStorageChunks < ActiveRecord::Migration
  def up
    create_table :storage_chunks do |t|
      t.integer :file_id
      t.integer :idx
      t.binary  :data, :limit => 1_000_000
    end

    remove_column :stored_files, :blob
    rename_table  :stored_files, :storage_files
  end

  def down
    rename_table :storage_files, :stored_files
    add_column :stored_files, :blob, :binary
    drop_table :storage_chunks
  end
end
