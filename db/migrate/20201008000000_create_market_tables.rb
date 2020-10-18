class CreateMarketTables < ActiveRecord::Migration[6.0]
  def up
    # 商品
    create_table :items do |t|
      t.integer           :user_id,          null: false
      t.integer           :category_id,      null: false
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
    add_index :items, %i(user_id category_id)

    # 商品画像
    create_table :item_images do |t|
      t.integer           :item_id
      t.string            :image,            null: false
      t.text              :note
      t.timestamps                           null: false
    end

    # カテゴリ
    create_table :categories do |t|
      t.string            :name,             null: false
      t.text              :note
      t.timestamps                           null: false
    end
  end

  def down
    drop_table :items
    drop_table :item_images
    drop_table :categories
  end
end
