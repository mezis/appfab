class AddImpactCacheToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas,    :impact_cache, :integer, :limit => 2
    add_column :ideas,    :stars_cache,  :integer, :limit => 1
    add_column :ideas,    :votes_cache,  :integer, :limit => 2, :default => 0
    add_column :comments, :votes_cache,  :integer, :limit => 2, :default => 0

    update %Q{
      UPDATE #{qtn 'ideas'} SET impact_cache = NULL
    }.gsub(/\s+/, ' ')

    update %Q{
      UPDATE #{qtn 'ideas'}
      SET impact_cache =
        1000 * #{qtn 'ideas'}.rating / (#{qtn 'ideas'}.design_size + #{qtn 'ideas'}.development_size)
      WHERE TRUE
      AND ideas.rating           IS NOT NULL
      AND ideas.design_size      IS NOT NULL
      AND ideas.development_size IS NOT NULL      
    }.gsub(/\s+/, ' ')


    %w(idea comment).each do |model|
      t = qtn model.pluralize
      m = model.titleize

      vote_counts = select_rows %Q{
        SELECT votes.subject_id AS idea_id,
          count(1) AS vote_count
        FROM votes
        WHERE votes.subject_type = '#{m}'
        GROUP BY votes.subject_id
      }.gsub(/\s+/, ' ')

      vote_counts.each do |id, count|
        update %Q{
          UPDATE #{t}
          SET votes_cache = #{count}
          WHERE id = #{id}
        }.gsub(/\s+/, ' ')
      end
    end
  end

  def down
    remove_column :ideas,    :impact_cache
    remove_column :ideas,    :stars_cache
    remove_column :ideas,    :votes_cache
    remove_column :comments, :votes_cache
  end

  private

  def qtn(*args)
    ActiveRecord::Base.connection.quote_table_name(*args)
  end

  def qcn(*args)
    ActiveRecord::Base.connection.quote_column_name(*args)
  end
end
