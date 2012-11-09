class ConvertIdeaStatesToInteger < ActiveRecord::Migration
  States = %w(submitted vetted voted picked designed approved implemented signed_off live)
  def up
    add_column :ideas, :state_integer, :integer
    States.each_with_index do |state_name, index|
      update %Q{
        UPDATE ideas SET state_integer = #{index} WHERE state = '#{state_name}'
      }
    end
    remove_column :ideas, :state
    rename_column :ideas, :state_integer, :state
  end

  def down
    rename_column :ideas, :state, :state_integer
    add_column :ideas, :state, :string
    States.each_with_index do |state_name, index|
      update %Q{
        UPDATE ideas SET state = '#{state_name}' WHERE state_integer = #{index}
      }
    end
    remove_column :ideas, :state_integer
  end
end
