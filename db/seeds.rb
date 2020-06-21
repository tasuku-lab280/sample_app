20.times do |n|
  name  = "会員#{n+1}"
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password)
end

users = User.order(:created_at).first(10)
20.times do |n|
  content = "サンプル内容#{n+1}"
  category = Post.category.values.sample
  users.each { |user| user.posts.create!(content: content, category: category) }
end

# 作成するユーザー・メッセージの個数
message_count = 3

ApplicationRecord.transaction do
  # メッセージを全消去した上で，サンプルメッセージを作成。メッセージを作成したユーザーはランダムに決定する
  ChatMessage.destroy_all
  user_ids = User.ids
  message_list = []
  message_count.times do |n|
    user_id = user_ids.sample
    line_count = rand(1..4)
    # Fakerで１〜４行のランダムメッセージを作成
    content = Faker::Lorem.paragraphs(number: line_count).join("\n")
    message_list << { user_id: user_id, content: content }
  end
  ChatMessage.create!(message_list)
end
puts '初期データの追加が完了しました！'
