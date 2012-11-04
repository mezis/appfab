class CreateUserBookmarks < ActiveRecord::Migration
  def self.up
    create_table :user_bookmarks do |t|
      t.integer :idea_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_bookmarks
  end
end
