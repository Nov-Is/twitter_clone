# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Jonny' }
    username { 'jon' }
    birth_date { '2000-01-01' }
    phone_number { '00000000000' }
    email { 'jon@example.com' }
    password { 'jontest1' }
  end
end
