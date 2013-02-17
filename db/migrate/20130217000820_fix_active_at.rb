class FixActiveAt < ActiveRecord::Migration
  def up
    update %Q{
      UPDATE ideas
      SET active_at = updated_at
      WHERE active_at IS NULL
      OR active_at < updated_at
    }
  end

  def down
    # nothing to do
  end
end
