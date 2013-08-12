class AddCounterCacheForAttachments < ActiveRecord::Migration
  def up
    add_column :ideas,    :attachments_count, :integer, :default => 0
    add_column :comments, :attachments_count, :integer, :default => 0
  end

  def down
    remove_column :ideas,    :attachments_count
    remove_column :comments, :attachments_count
  end
end
