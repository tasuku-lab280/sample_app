Translatable = Struct.new(:klass) do
  def t_l; klass.model_name.human; end
  def t_ar(attr); klass.human_attribute_name(attr); end
  def create!(arg); klass.create!(arg); end
end

USERS = 20
CREDIT_CARDS_PER_USER = 3
DESTINATIONS_PER_USER = 3
CATEGORIES = 5
ITEMS = 50
ITEM_CATEGORIES = 50


## 会員
USERS.times do |n|
  name  = "会員#{n+1}"
  email = "dev+user#{n+1}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password)
end


# クレジットカード
CC = Translatable.new(Creditcard)
counter = 0
User.all.each do |u|
  credit_cards = (1..CREDIT_CARDS_PER_USER).map do |i|
    counter += 1
    {
      user_id:              u.id,
      status:               Creditcard.status.values[i % 2],
      stripe_creditcard_id: SecureRandom.base64,
      masked_number:        i.to_s.rjust(12, rand(0..9).to_s).ljust(16, 'X'),
      expire_date:          (Time.current + counter.months).strftime('%m/%y'),
      brand:                %w(visa mastercard amex)[i % 2],
    }
  end
  CC.create!(credit_cards)
end


# 配送先
D = Translatable.new(Destination)
User.all.each do |u|
  user_name = u.name
  destinations = (1..DESTINATIONS_PER_USER).map do |i|
    {
      user_id:         u.id,
      last_name:       "#{user_name}の#{Destination.human_attribute_name(:last_name)}",
      first_name:      "#{user_name}の#{Destination.human_attribute_name(:first_name)}",
      last_name_kana:  "#{user_name}の#{Destination.human_attribute_name(:last_name_kana)}",
      first_name_kana: "#{user_name}の#{Destination.human_attribute_name(:first_name_kana)}",
      postal_code:     7.times.inject('') { |postal| postal.to_s + rand(9).to_s },
      prefecture:      rand(1..47),
      address1:        "#{user_name}の#{Destination.human_attribute_name(:address1)}",
      address2:        "#{user_name}の#{Destination.human_attribute_name(:address2)}",
      address3:        "#{user_name}の#{Destination.human_attribute_name(:address3)}",
      tel:             '00000000000',
    }
  end
  D.create!(destinations)
end
User.first.update!(
  selected_creditcard_id: Creditcard.first.id,
  selected_destination_id: Destination.first.id, 
)


## 通知
user = User.find(1)
sender = User.find(2)
notices = Array.new(50) do |n|
  atrs = if n % 3 != 0
           [sender.id, sender.name]
         else
           [nil, I18n.t('application.name')]
         end
  {
    user_id: user.id,
    sender_id: atrs[0],
    body: "<span class='font-weight-bold'>#{atrs[1]}</span>さんがサンプル通知#{n}を作成しました。",
    url: '/',
    read_at: (n % 4 == 0 ? nil : Time.current)
  }
end
Notice.create!(notices)


# カテゴリ
tree1 = [1, 2, 3, 4]
tree2 = [5, 6, 7, 8]
trees = [tree1, tree2]
CG = Translatable.new(Category)
trees.each do |tree|
  categories = tree.each_with_index.map do |seq, i|
    {
      seq_path: "/#{tree[0..i].join('/')}/",
      seq: seq,
      name: "#{CG.t_l}#{tree[i]}"
    }
  end
  CG.create!(categories)
end


# 商品
I = Translatable.new(Item)
items = (1..ITEMS).map do |i|
  item = {
    user_id:          rand(1..USERS),
    name:             "#{I.t_l}#{i}",
    body:             'text',
    price:            rand(1..10)*500,
    condition: Item.condition.values.sample,
    delivery_fee: Item.delivery_fee.values.sample,
    prefecture: Item.prefecture.values.sample,
    days_to_ship: Item.days_to_ship.values.sample,
    sales_status: Item.sales_status.values.sample,
  }
end
I.create!(items)


# 商品カテゴリ
category_ids = Category.pluck(:id)
item_categories = Item.all.map do |item|
  {
    category_id: category_ids.sample,
    item_id: item.id
  }
end
ItemCategory.create!(item_categories)


# 記事
COUNT = 50
USER_IDS = [1, 2, 3]
results = Array.new(COUNT) do |i|
  num = i + 1
  {
    user_id: USER_IDS[i % 3],
    status: Article.status.values[i % 3],
    title: "サンプルタイトル#{num}",
    body: "サンプル本文#{num}",
  }
end
Article.create!(results)

puts '初期データの追加が完了しました！'
