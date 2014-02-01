class AddsTextacularIndices < ActiveRecord::Migration
  CREATE_INDEX = <<-SQL
    CREATE INDEX index_fts_%<column>s ON ideas USING gin(to_tsvector('english', %<column>s));
  SQL

  DROP_INDEX = <<-SQL
    DROP INDEX index_fts_%<column>s;
  SQL

  COLUMNS = %w[ title problem solution metrics category ]

  def up
    COLUMNS.each do |col|
      execute((CREATE_INDEX % { column: col }).strip)
    end
  end

  def down
    COLUMNS.each do |col|
      execute((DROP_INDEX % { column: col }).strip)
    end
  end
end
