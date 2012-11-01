# encoding: UTF-8
class AddVotingPowerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :voting_power, :integer
  end
end
