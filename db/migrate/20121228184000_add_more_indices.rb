class AddMoreIndices < ActiveRecord::Migration
  def up
    add_index :ideas, [:account_id, :state, :active_at]
    remove_index :ideas, :state
    add_index :users, :login_id
  end

  def down
    remove_index :users, :login_id
    add_index :ideas, :state
    remove_index :ideas, [:account_id, :state, :active_at]
  end
end
