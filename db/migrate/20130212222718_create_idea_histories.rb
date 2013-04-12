class CreateIdeaHistories < ActiveRecord::Migration
  def self.up
    create_table :idea_histories do |t|
      t.integer  :idea_id
      t.string   :type
      t.text     :payload
      t.integer  :subject_id
      t.string   :subject_type
      t.datetime :created_at
    end

    insert %Q{
      INSERT INTO idea_histories (idea_id, type, subject_id, subject_type, created_at)
      SELECT idea_id, "Idea::History::Comment", id, "Comment", created_at
      FROM comments
    }

    insert %Q{
      INSERT INTO idea_histories (idea_id, type, created_at)
      SELECT id, "Idea::History::Creation", created_at
      FROM ideas
    }

    add_index :idea_histories, [:idea_id, :created_at]
  end

  def self.down
    drop_table :idea_histories
  end
end
