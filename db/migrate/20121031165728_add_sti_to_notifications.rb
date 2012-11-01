# encoding: UTF-8
class AddStiToNotifications < ActiveRecord::Migration
  def up
    add_column    :notifications, :type, :string
    rename_column :notifications, :user_id, :recipient_id
  end

  def down
    rename_column :notifications, :recipient_id, :user_id
    remove_column :notifications, :type, :string
  end
end
