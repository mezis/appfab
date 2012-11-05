class AddActiveAtToIdea < ActiveRecord::Migration
  def up
    add_column :ideas, :active_at, :datetime
    update %{
      UPDATE ideas SET active_at = updated_at
    }
  end

  def down
    remove_column :ideas, :active_at
  end
end
