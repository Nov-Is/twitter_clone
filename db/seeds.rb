# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

3.times do |n|
  User.create!(
    name: "name#{n + 1}",
    username: "username#{n + 1}",
    self_introduction: "ruby on railsの学習をしています。
よろしくお願いします。",
    location: '神奈川 横浜市',
    website: 'https://www.google.com',
    email: "test#{n + 1}@example.com",
    password: 'hogefuga',
    phone_number: '00000000000',
    birth_date: '2000-01-01',
    uid: SecureRandom.uuid,
    icon_image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/40x40.png')),
                                                       filename: 'icon.jpg'),
    header_image: ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join('app/assets/images/800x300.png')), filename: 'header.jpg'
    )
  )
end

Relationship.create!(
  follower_id: 1, # フォローしている
  followed_id: 2  # フォローされている
)

3.times do |n|
  10.times do |m|
    Post.create!(
      user_id: n + 1,
      content: "#{n + 1}-#{m + 1}のテスト投稿です"
    )
  end
end

20.times do |n|
  Post.create!(
    user_id: 2,
    content: "2-#{n + 1}の追加投稿です。"
  )
end

3.times do |n|
  Comment.create!(
    user_id: n + 1,
    comment: 'コメントです。',
    post_id: 2
  )
end

3.times do |n|
  user = User.find(n + 1)
  post = Post.find(1)
  Favorite.create!(
    user_id: user.id,
    favorable: post
  )
  Repost.create!(
    user_id: user.id,
    repostable: post
  )

  other_user = n + 1 == 2 ? User.find(3) : User.where.not(id: n + 1).first
  Notification.create(
    visitor_id: user.id,
    visited_id: other_user.id,
    action: 'favorite',
    notifiable_type: 'Post',
    notifiable_id: other_user.posts.first.id
  )
end
