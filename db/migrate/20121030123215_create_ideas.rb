class CreateIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas do |t|
      t.string :title
      t.text :problem
      t.text :solution
      t.text :metrics
      t.date :deadline
      t.integer :author_id
      t.integer :design_size
      t.integer :development_size
      t.integer :rating
      t.string :state
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :ideas
  end
end
