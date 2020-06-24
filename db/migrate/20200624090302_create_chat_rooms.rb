class CreateChatRooms < ActiveRecord::Migration[6.0]
  def up
    create_table :chat_rooms do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :chat_rooms
  end
end
