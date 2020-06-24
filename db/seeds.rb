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

ChatRoom.create!(
  name: "チャットルーム1"
)
  
1.upto(3) do |n|
  ChatUser.create!(
    chat_room_id: 1,
    user_id: n
  )
end

line_count = rand(1..4)
1.upto(20) do |n|
  ChatMessage.create!(
    chat_room_id: 1,
    user_id: rand(1..3),
    content: Faker::Lorem.paragraphs(number: line_count).join("\n")
  )
end

puts '初期データの追加が完了しました！'
