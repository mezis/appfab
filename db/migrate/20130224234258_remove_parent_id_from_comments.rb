class RemoveParentIdFromComments < ActiveRecord::Migration
  def up
    remove_column :comments, :parent_id
  end

  def down
    add_column :comments, :parent_id, :integer
  end
end
