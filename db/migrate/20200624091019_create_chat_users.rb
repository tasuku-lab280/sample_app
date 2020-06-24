class CreateChatUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :chat_users do |t|
      t.integer :chat_room_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :chat_users, [:chat_room_id, :user_id]
  end

  def down
    drop_table :chat_users
  end
end
