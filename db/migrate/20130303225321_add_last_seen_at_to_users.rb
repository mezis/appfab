class AddLastSeenAtToUsers < ActiveRecord::Migration
  def up
    add_column :users, :last_seen_at, :datetime
  end

  def down
    remove_column :users, :last_seen_at
  end
end
