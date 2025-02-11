# frozen_string_literal: true

class Post < ApplicationRecord
  include SharedLogic

  belongs_to :user
  has_many_attached :images
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :reposts, as: :repostable, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, length: { maximum: 140 }
end
