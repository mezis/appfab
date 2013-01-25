class RemoveKindFromIdeas < ActiveRecord::Migration
  def up
    remove_column :ideas, :kind
  end

  def down
    add_column :ideas, :kind, :string

    update %Q{
      UPDATE ideas SET kind = 'feature';
    }
  end
end
