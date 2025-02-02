# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, length: { maximum: 140 }

  def favorited?(user)
    favorites.where(user_id: user.id).present?
  end
end
