class MakeIdeaIdsBigger < ActiveRecord::Migration
  def up
    change_column :ideas, :id, :integer, limit:8
  end

  def down
    # no down migration
  end
end
