class AddKindToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :kind, :string
    update %Q(
      UPDATE ideas SET kind = 'feature'
    )
  end

  def down
    remove_column :ideas, :kind
  end
end
