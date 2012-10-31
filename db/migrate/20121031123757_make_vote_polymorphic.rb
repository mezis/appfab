class MakeVotePolymorphic < ActiveRecord::Migration
  def up
    add_column :votes, :subject_id,   :integer
    add_column :votes, :subject_type, :string

    update %Q{
      UPDATE votes SET subject_type = "Idea", subject_id = idea_id;
    }

    remove_column :votes, :idea_id
  end

  def down
    add_column :votes, :idea_id, :integer

    update %Q{
      UPDATE votes SET idea_id = subject_id
      WHERE subject_type = "Idea"
    }

    remove_column :votes, :subject_id
    remove_column :votes, :subject_type
  end
end
