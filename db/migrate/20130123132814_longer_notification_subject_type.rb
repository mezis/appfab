class LongerNotificationSubjectType < ActiveRecord::Migration
  def up
    change_column :notifications, :subject_type, :string, limit:255
  end

  def down
    # no down migration necessary
  end
end
