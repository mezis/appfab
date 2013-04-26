class CreateIdeaHistories < ActiveRecord::Migration
  def up
    create_table :idea_histories do |t|
      t.integer  :idea_id
      t.string   :type
      t.text     :payload
      t.integer  :subject_id
      t.string   :subject_type
      t.datetime :created_at
    end

    insert sanitize([
      %Q{
        INSERT INTO idea_histories (idea_id, type, subject_id, subject_type, created_at)
        SELECT idea_id, ?, id, ?, created_at
        FROM comments
      }, 
      "Idea::History::Comment", "Comment"
    ])

    insert sanitize([
      %Q{
        INSERT INTO idea_histories (idea_id, type, created_at)
        SELECT id, ?, created_at
        FROM ideas
      },
      "Idea::History::Creation"
    ])

    add_index :idea_histories, [:idea_id, :created_at]
  end

  def down
    drop_table :idea_histories
  end

  private

  def sanitize(*args)
    ActiveRecord::Base.send :sanitize_sql_array, *args
  end
end
