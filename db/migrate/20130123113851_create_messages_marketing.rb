class CreateMessagesMarketing < ActiveRecord::Migration
  def change
    create_table :messages_marketing do |t|
      t.text :payload
      t.string :link

      t.timestamps
    end
  end
end
