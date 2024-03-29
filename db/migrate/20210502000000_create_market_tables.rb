class CreateMarketTables < ActiveRecord::Migration[6.0]
  def up
    # 会員
    change_table :users do |t|
      t.integer :selected_creditcard_id,   after: :remember_created_at
      t.integer :selected_destination_id,  after: :selected_creditcard_id
    end
    add_index :users, :selected_creditcard_id
    add_index :users, :selected_destination_id

    # クレジットカード
    create_table :creditcards do |t|
      t.integer    :user_id,              null: false
      t.string     :status,               null: false
      t.string     :stripe_creditcard_id, null: false
      t.string     :masked_number,        null: false
      t.string     :expire_date,          null: false
      t.string     :brand,                null: false
      t.text       :note
      t.datetime   :deleted_at
      t.timestamps                   null: false
    end
    add_index :creditcards, :user_id

    # 配送先
    create_table :destinations do |t|
      t.integer    :user_id,         null: false
      t.string     :last_name,       null: false, limit: 32
      t.string     :first_name,      null: false, limit: 32
      t.string     :last_name_kana,  null: false, limit: 32
      t.string     :first_name_kana, null: false, limit: 32
      t.string     :postal_code,     null: false
      t.integer    :prefecture,      null: false
      t.string     :address1,        null: false
      t.string     :address2,        null: false
      t.string     :address3
      t.string     :tel
      t.text       :note
      t.timestamps                   null: false
    end
    add_index :destinations, :user_id

    # 購入
    create_table :payments do |t|
      t.integer     :user_id,             null: false
      t.integer     :creditcard_id,       null: false
      t.integer     :item_id,             null: false
      t.string      :status,              null: false, default: :success
      t.integer     :price,               null: false
      t.string      :result_code
      t.string      :error_message
      t.text        :note
      t.timestamps                        null: false
    end
    add_index :payments, %i(user_id creditcard_id item_id)

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
    change_table :users do |t|
      t.remove :selected_creditcard_id
      t.remove :selected_destination_id
    end
    drop_table :creditcards
    drop_table :destinations
    drop_table :payments
    drop_table :items
    drop_table :item_images
    drop_table :categories
    drop_table :item_categories
    drop_table :comments
    drop_table :notices
  end
end
