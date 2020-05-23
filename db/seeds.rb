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
