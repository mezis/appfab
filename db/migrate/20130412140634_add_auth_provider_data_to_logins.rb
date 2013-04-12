class AddAuthProviderDataToLogins < ActiveRecord::Migration
  def up
    add_column :logins, :auth_provider_data, :text
  end

  def down
    remove_column :logins, :auth_provider_data
  end
end
