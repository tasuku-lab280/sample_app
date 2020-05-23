class CreatePosts < ActiveRecord::Migration[5.2]
  def up
    create_table :posts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end

  def down
    drop_table :posts
  end
end
