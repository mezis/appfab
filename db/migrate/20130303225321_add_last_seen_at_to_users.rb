class AddLastSeenAtToUsers < ActiveRecord::Migration
  def up
    add_column :users, :last_seen_at, :datetime
    update %Q{
      UPDATE users
      INNER JOIN logins
      ON users.login_id = logins.id
      SET users.last_seen_at = logins.last_sign_in_at
    }
  end

  def down
    remove_column :users, :last_seen_at
  end
end
