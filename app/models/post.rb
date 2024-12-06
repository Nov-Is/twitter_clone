# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :image
  has_many :favorites, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
