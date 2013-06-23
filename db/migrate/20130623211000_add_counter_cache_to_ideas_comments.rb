class AddCounterCacheToIdeasComments < ActiveRecord::Migration
  def up
    add_column :ideas, :comments_count, :integer, :default => 0
  end

  def down
    remove_column :ideas, :comments_count
  end
end
