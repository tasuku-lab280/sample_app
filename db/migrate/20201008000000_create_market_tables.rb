class CreateMarketTables < ActiveRecord::Migration[6.0]
  def up
    # 商品
    create_table :items do |t|
      t.integer           :user_id,          null: false
      t.string            :name,             null: false
      t.text              :body,             null: false
      t.integer           :price,            null: false
      t.string            :condition,        null: false
      t.string            :delivery_fee,     null: false
      t.integer           :prefecture,       null: false
      t.string            :days_to_ship,     null: false
      t.string            :sales_status,     null: false
      t.text              :note
      t.timestamps                           null: false
    end
    add_index :items, :user_id

    # 商品画像
    create_table :item_images do |t|
      t.integer           :item_id
      t.string            :image,            null: false
      t.text              :note
      t.timestamps                           null: false
    end
    add_index :item_images, :item_id

    # カテゴリ
    create_table :categories do |t|
      t.string     :seq_path, null: false
      t.integer    :seq
      t.string     :name,     null: false
      t.string     :image
      t.text       :detail
      t.text       :note
      t.timestamps            null: false
    end
    add_index :categories, :seq_path

    # 商品カテゴリ
    create_table :item_categories do |t|
      t.string     :category_id, null: false
      t.string     :item_id,     null: false
      t.timestamps               null: false
    end
    add_index :item_categories, %i(category_id item_id)

    # コメント
    create_table :comments do |t|
      t.integer           :user_id,          null: false
      t.integer           :item_id,          null: false
      t.text              :body,             null: false
      t.timestamps                           null: false
    end
    add_index :comments, %i(user_id item_id)

    # 通知
    create_table :notices do |t|
      t.integer           :user_id,          null: false
      t.integer           :sender_id
      t.text              :body,             null: false
      t.text              :url,              null: false
      t.datetime          :read_at
      t.text              :note
      t.timestamps                           null: false
    end
    add_index :notices, %i(user_id sender_id)
  end

  def down
    drop_table :items
    drop_table :item_images
    drop_table :categories
    drop_table :item_categories
    drop_table :comments
    drop_table :notices
  end
end
