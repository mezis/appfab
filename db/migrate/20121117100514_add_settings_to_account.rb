class AddSettingsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :settings, :text
  end
end
