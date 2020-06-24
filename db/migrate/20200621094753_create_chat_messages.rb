class CreateChatMessages < ActiveRecord::Migration[5.2]
  def up
    create_table :chat_messages do |t|
      t.integer :chat_room_id, null: false
      t.integer :user_id, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :chat_messages, [:chat_room_id, :user_id]
  end

  def down
    drop_table :chat_messages
  end
end
