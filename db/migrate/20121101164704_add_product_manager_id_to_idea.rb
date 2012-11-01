class AddProductManagerIdToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :product_manager_id, :integer
  end
end
