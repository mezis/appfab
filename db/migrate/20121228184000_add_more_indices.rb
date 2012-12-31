class AddMoreIndices < ActiveRecord::Migration
  def up
    add_index :ideas, [:account_id, :state]
  end

  def down
    remove_index :ideas, [:account_id, :state]
  end
end
