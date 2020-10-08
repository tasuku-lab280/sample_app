class CreateMarketTables < ActiveRecord::Migration[6.0]
  def up
    # 商品
    create_table :items do |t|
      t.integer           :user_id,          null: false
      t.string            :name,             null: false
      t.text              :body,             null: false
      t.integer           :price,            null: false
      t.string            :condition,        null: false
      t.string            :image
      t.text              :note
      t.timestamps                           null: false
    end
    add_index :items, :user_id
  end

  def down
    drop_table :items
  end
end