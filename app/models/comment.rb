# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many_attached :comment_images

  validates :comment, length: { maximum: 140 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
