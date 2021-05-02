class CreateArticleTables < ActiveRecord::Migration[6.0]
  def up
    # 記事
    create_table :articles do |t|
      t.integer    :user_id,         null: false
      t.string     :status,          null: false
      t.string     :title,           null: false
      t.text       :body,            null: false, limit: 65535
      t.text       :note
      t.timestamps                   null: false
    end
    add_index :articles, :user_id
  end

  def down
    drop_table :articles
  end
end
