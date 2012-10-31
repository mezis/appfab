class AddAutoAdoptToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :auto_adopt, :boolean
    add_column :accounts, :domain,     :string

    update %Q(
      UPDATE `accounts` SET auto_adopt = (SELECT (1 = 0))
    )
  end

  def self.down
    remove_column :accounts, :auto_adopt
    remove_column :accounts, :domain
  end
end
