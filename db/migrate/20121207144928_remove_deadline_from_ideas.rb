class RemoveDeadlineFromIdeas < ActiveRecord::Migration
  def up
    remove_column :ideas, :deadline
  end

  def down
    add_column :ideas, :deadline, :date
  end
end
