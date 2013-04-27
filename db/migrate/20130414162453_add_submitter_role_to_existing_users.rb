class AddSubmitterRoleToExistingUsers < ActiveRecord::Migration
  def up
    timestamp = Time.current
    insert(sanitize([
      %Q{
        INSERT INTO user_roles (user_id, name, created_at, updated_at)
        SELECT user_id, ?, ?, ?
        FROM user_roles AS source
        GROUP BY user_id 
      }, 'submitter', timestamp, timestamp
    ]))
  end

  def down
    delete(sanitize([
      'DELETE FROM user_roles WHERE name = ?',
      'submitter'
    ]))
  end

  private

  def sanitize(*args)
    ActiveRecord::Base.send :sanitize_sql_array, *args
  end
end
