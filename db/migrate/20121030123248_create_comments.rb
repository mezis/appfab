# encoding: UTF-8
class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :idea_id
      t.integer :parent_id
      t.integer :author_id
      t.integer :rating
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
