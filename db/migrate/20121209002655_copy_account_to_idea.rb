class CopyAccountToIdea < ActiveRecord::Migration
  def self.up
    add_column :ideas, :account_id, :integer

    update %{
      UPDATE ideas
      SET account_id = (
        SELECT account_id
        FROM users
        WHERE id = ideas.author_id
      )
    }
  end


  def self.down
    remove_column :ideas, :account_id
  end
end
