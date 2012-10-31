class CreateVettings < ActiveRecord::Migration
  def self.up
    create_table :vettings do |t|
      t.user_id :integer
      t.idea_id :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :vettings
  end
end
