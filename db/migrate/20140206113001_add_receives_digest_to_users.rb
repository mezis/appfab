class AddReceivesDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receives_digest, :boolean, default: true
  end
end
