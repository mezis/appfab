class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string  :mime_type
      t.string  :name
      t.string  :owner_type
      t.integer :owner_id
      t.integer :uploader_id
      t.string  :file_uid
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
