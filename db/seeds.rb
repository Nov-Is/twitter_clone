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
    email: "test#{n + 1}@example.com",
    password: 'hogefuga',
    phone_number: '00000000000',
    birth_date: '2000-01-01',
    uid: SecureRandom.uuid,
    image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/40x40.png')),
                                                  filename: 'test.jpg')
  )
end

Relationship.create!(
  followee_id: 1,
  follower_id: 2
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
