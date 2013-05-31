class AddStateToUsers < ActiveRecord::Migration
  def up
    add_column :users, :state, :integer, limit:1

    update <<-SQL
      UPDATE users SET state = 0;
    SQL
  end

  def down
    remove_column :users, :state
  end
end
