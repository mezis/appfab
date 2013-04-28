class AddImpactCacheToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas,    :impact_cache, :integer, :limit => 2
    add_column :ideas,    :stars_cache,  :integer, :limit => 1
    add_column :ideas,    :votes_cache,  :integer, :limit => 2, :default => 0
    add_column :comments, :votes_cache,  :integer, :limit => 2, :default => 0

    update %Q{
      UPDATE ideas SET ideas.impact_cache = NULL
    }

    update %Q{
      UPDATE ideas
      SET ideas.impact_cache = 
        1000 * ideas.rating / (ideas.design_size + ideas.development_size)
      WHERE TRUE
      AND ideas.rating           IS NOT NULL
      AND ideas.design_size      IS NOT NULL
      AND ideas.development_size IS NOT NULL      
    }

    update %Q{
      UPDATE ideas
      LEFT JOIN (
        SELECT 
          votes.subject_id AS idea_id,
          count(*) AS vote_count
        FROM votes
        WHERE votes.subject_type = 'Idea'
        GROUP BY votes.subject_id
      ) AS votes_aggregate
      ON
        ideas.id = votes_aggregate.idea_id
      SET
        ideas.votes_cache = votes_aggregate.vote_count
    }.gsub(/\s+/, ' ')


    update %Q{
      UPDATE comments
      LEFT JOIN (
        SELECT 
          votes.subject_id AS comment_id,
          count(*) AS vote_count
        FROM votes
        WHERE votes.subject_type = 'Comment'
        GROUP BY votes.subject_id
      ) AS votes_aggregate
      ON
        comments.id = votes_aggregate.comment_id
      SET
        comments.votes_cache = votes_aggregate.vote_count
    }.gsub(/\s+/, ' ')
  end

  def down
    remove_column :ideas,    :impact_cache
    remove_column :ideas,    :stars_cache
    remove_column :ideas,    :votes_cache
    remove_column :comments, :votes_cache
  end
end
