# frozen_string_literal: true

class Comment < ApplicationRecord
  include SharedLogic

  belongs_to :user
  belongs_to :post
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :reposts, as: :repostable, dependent: :destroy
  has_many_attached :comment_images

  validates :comment, length: { maximum: 140 }
end
