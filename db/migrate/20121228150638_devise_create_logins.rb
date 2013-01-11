class DeviseCreateLogins < ActiveRecord::Migration
  def up
    # remove_column :users, :role
    rename_table :users, :logins

    create_table :users do |t|
      t.integer  :login_id
      t.integer  :account_id
      t.integer  :karma
      t.integer  :voting_power
      t.datetime :created_at
      t.datetime :updated_at
    end

    insert %Q{
      INSERT INTO users
      SELECT id, id, account_id, karma, voting_power, created_at, updated_at
      FROM logins
    }

    # pgSQL only
    if ActiveRecord::Base.connection.class.name =~ /PostgreSQL/
      execute %Q{
        SELECT SETVAL('users_id_seq', MAX(id))
        FROM users
      }
    end

    remove_columns :logins, :account_id, :karma, :voting_power

    add_index :users, [:account_id, :login_id]
  end

  def down
    change_table :logins do |t|
      t.integer :account_id
      t.integer :karma
      t.integer :voting_power
    end

    insert %Q{
      UPDATE logins
      LEFT JOIN users
      ON logins.id = users.login_id
      SET 
        logins.account_id   = users.account_id,
        logins.karma        = users.karma,
        logins.voting_power = users.voting_power
    }

    drop_table :users
    rename_table :logins, :users
    # add_column :users, :role, :string
  end
end
