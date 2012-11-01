# encoding: UTF-8
class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id
      t.string :subject_type
      t.integer :subject_id
      t.string :body
      t.boolean :unread
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
