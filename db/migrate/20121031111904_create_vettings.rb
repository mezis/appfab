# encoding: UTF-8
class CreateVettings < ActiveRecord::Migration
  def self.up
    create_table :vettings do |t|
      t.integer :user_id
      t.integer :idea_id
      t.timestamps
    end
  end

  def self.down
    drop_table :vettings
  end
end
