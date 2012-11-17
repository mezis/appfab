class AddSizeToAttachments < ActiveRecord::Migration
  def up
    add_column :attachments, :size, :integer
  end

  def down
    remove_column :attachments, :size
  end
end
